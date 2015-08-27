
#include "..\include\basic.h"
#include "..\include\kernel.h"
#include "..\include\syscall.h"

asm _DATA ends
asm _TEXT segment byte public 'CODE'

asm .486
asm .MODEL TINY

/* Default process is the kernel itself */
unsigned short current_proc = 0x0000;
unsigned short proc_slot_num = 0x0000;
unsigned short proc_slot_remain = 0x0000;
ProcessNode far *sys_proc_ptr = 0x00000000;

asm _TEXT ends
asm _DATA segment word public 'DATA'

void IdleProcess()
{
    unsigned short i;
    unsigned short j = 0;
    SysPutString("Process 0 now running\n");
    while(1)
    {
        for(i = 0;i < 65535;i++) ;
        j++;
        asm cli
        SysPrintSignedShortDec(j);
        SysPutChar('a');
        asm sti
    }
}

void IdleProcess2()
{
    unsigned short i;
    unsigned short j = 0;
    SysPutString("Process 1 now running\n");
    while(1)
    {
        for(i = 0;i < 65535;i++) ;
        j++;
        asm cli
        SysPrintSignedShortDec(j);
        SysPutChar('b');
        asm sti
    }
}

/* Can only be called inside the interrupt handler int70h()
BP is the saved position of SP. For more information about the offset please take
a look at timer.c */
void SaveContext(unsigned short saved_bp) /* public */
{
    ProcessNode far *current_node = sys_proc_ptr + current_proc;
    asm les bx, current_node;
    /* Restore BP */
    asm mov sp, bp
    asm pop bp

    asm mov ax, [bp + 16]
    asm mov cx, [bp + 12]
    asm mov dx, [bp + 10]
    asm mov si, [bp + 8]
    asm mov di, [bp + 6]
    asm mov es:[bx + 0], ax
    asm mov es:[bx + 4], cx
    asm mov es:[bx + 6], dx
    asm mov es:[bx + 8], si
    asm mov es:[bx + 10], di
    /* Save bx */
    asm mov ax, [bp + 14]
    asm mov es:[bx + 2], ax
    /* Save old bp */
    asm mov ax, [bp + 4]
    asm mov es:[bx + 14], ax
    /* Save ds */
    asm mov ax, [bp + 2]
    asm mov es:[bx + 20], ax
    /* Save es */
    asm mov ax, [bp + 0]
    asm mov es:[bx + 22], ax
    /* Save ss */
    asm mov ax, [bp + 18]
    asm mov es:[bx + 24], ax
    /* Save cs */
    asm mov ax, [bp + 22]
    asm mov es:[bx + 16], ax
    /* Save IP */
    asm mov ax, [bp + 20]
    asm mov es:[bx + 18], ax
    /* Save flags */
    asm mov ax, [bp + 24]
    asm mov es:[bx + 26], ax
    /* Finally save old SP = bp + 26 */
    asm mov es:[bx + 12], bp
    asm add word ptr es:[bx + 12], 26

    /* Wrap */
    asm push bp
    asm mov bp, sp
    asm push si
    asm push di
    /* Compiler will insert:
    pop di
    pop si
    mov sp, bp
    pop bp
    ret
     */
    return;
}

/* Select next runnable process in the process table. For now we use a
round-robin scheduling. If there is not a runnable process we will just
return process 0, which is the System Idle Process */
unsigned short FindNextProcess()
{
    int i;
    ProcessNode far *current_node = (sys_proc_ptr + current_proc + 1);
    unsigned short current_status;
    /* Scan process number (current_proc + 1) to (proc_slot_num - 1)  */
    for(i = current_proc + 1;i < proc_slot_num;i++)
    {
        current_status = current_node->status;
        if(current_status == PROC_NODE_NEW || current_status == PROC_NODE_RUNNING)
        {
            /* If it is new then it is running afterwards */
            current_status = PROC_NODE_RUNNING;
            return i;
        }
        else current_node++;
    }
    /* Scan process nunber 1 to (current_proc) */
    current_node = sys_proc_ptr + 1;
    for(i = 1;i <= current_proc;i++)
    {
        current_status = current_node->status;
        if(current_status == PROC_NODE_NEW || current_status == PROC_NODE_RUNNING)
        {
            current_status = PROC_NODE_RUNNING;
            return i;
        }
        else current_node++;
    }
    /* If there is not an existing process then just run process 0 */
    return 0;
}

/* This function never returns. It will select a runnable process from the
process table and then jump to that process using an iret */
void Schedule() /* public */
{
    unsigned short next_proc;
    ProcessNode far *next_proc_node;
    unsigned short next_proc_status;

    next_proc = FindNextProcess();
    next_proc_node = sys_proc_ptr + next_proc;
    next_proc_status = next_proc_node->status;

    if(next_proc_status != PROC_NODE_NEW && next_proc_status != PROC_NODE_RUNNING)
        FatalError("Invalid Next Process Node Returned");
    /* Change current process number */
    current_proc = next_proc;

    asm les bx, next_proc_node
    /* es and bx should not change */
    asm mov cx, es:[bx + 4]
    asm mov dx, es:[bx + 6]
    asm mov si, es:[bx + 8]
    asm mov di, es:[bx + 10]
    asm mov bp, es:[bx + 14]
    /* Set up ds */
    asm mov ax, es:[bx + 20]
    asm mov ds, ax
    /* Set up stack (ss and sp) and we are using the new stack afterwards */
    asm mov ax, es:[bx + 24]
    asm mov ss, ax
    asm mov sp, es:[bx + 12]
    /* Set up ax */
    asm mov ax, es:[bx]

    /* IRET destination into stack: FLAGS CS IP */
    asm push es:[bx + 26]
    asm push es:[bx + 16]
    asm push es:[bx + 18]
    /* Push new es:bx */
    asm push es:[bx + 22]
    asm push es:[bx + 2]
    asm pop bx
    asm pop es
    /* Set CS:IP and FLAGS */
    asm iret
}

int InitProcessTable(unsigned short num_slot) /* public */
{
    unsigned short total = num_slot * sizeof(ProcessNode);
    ProcessNode far *current_node;
    unsigned short flags_bak;
    int i;

    proc_slot_num = num_slot;

    sys_proc_ptr = (ProcessNode far *)sys_mem_avail;
    current_node = sys_proc_ptr;
    /* Clear all memory. All unspecified registers are initialized to 0 */
    SegmentSet(current_node,0x0000,sizeof(ProcessNode) * num_slot);
    /* Set system stack (the same as the current one) */
    current_node->reg_ss = SYS_STACK_SEG;
    /* Reinitialize the system stack pointer (to the topmost) */
    current_node->reg_sp = 0xFFFE;
    /* Code segment and instruction pointer */
    current_node->reg_cs = SYS_CODE_SEG;
    /* Must be a near pointer */
    current_node->reg_ip = (void near *)IdleProcess;

    current_node->reg_ds = SYS_CODE_SEG;
    /* This is not necessary but just do it */
    current_node->reg_es = SYS_DATA_SEG;
    /* Get current flags */
    asm pushf
    asm pop ax
    asm mov flags_bak, ax
    /* Keep reserved bit 1111 0000 0010 1010 */
    flags_bak &= 0xF02A;
    /* Turn on IF */
    flags_bak |= 0x0200;
    /* Initialize the flags register */
    current_node->reg_flags = flags_bak;
    /* Ready for scheduling */
    current_node->status = PROC_NODE_NEW;
    current_node++;




    /* Set system stack (the same as the current one) */
    current_node->reg_ss = SYS_STACK_SEG;
    /* Reinitialize the system stack pointer (to the topmost) */
    current_node->reg_sp = 0xFFFE;
    /* Code segment and instruction pointer */
    current_node->reg_cs = SYS_CODE_SEG;
    /* Must be a near pointer */
    current_node->reg_ip = (void near *)IdleProcess2;

    current_node->reg_ds = SYS_CODE_SEG;
    /* This is not necessary but just do it */
    current_node->reg_es = SYS_DATA_SEG;
    /* Get current flags */
    asm pushf
    asm pop ax
    asm mov flags_bak, ax
    /* Keep reserved bit 1111 0000 0010 1010 */
    flags_bak &= 0xF02A;
    /* Turn on IF */
    flags_bak |= 0x0200;
    /* Initialize the flags register */
    current_node->reg_flags = flags_bak;
    /* Ready for scheduling */
    current_node->status = PROC_NODE_NEW;
    current_node++;
    /* Set system stack (the same as the current one) */
    current_node->reg_ss = SYS_STACK_SEG;
    /* Reinitialize the system stack pointer (to the topmost) */
    current_node->reg_sp = 0x0FFE;
    /* Code segment and instruction pointer */
    current_node->reg_cs = SYS_CODE_SEG;
    /* Must be a near pointer */
    current_node->reg_ip = (void near *)IdleProcess;

    current_node->reg_ds = SYS_CODE_SEG;
    /* This is not necessary but just do it */
    current_node->reg_es = SYS_DATA_SEG;
    /* Get current flags */
    asm pushf
    asm pop ax
    asm mov flags_bak, ax
    /* Keep reserved bit 1111 0000 0010 1010 */
    flags_bak &= 0xF02A;
    /* Turn on IF */
    flags_bak |= 0x0200;
    /* Initialize the flags register */
    current_node->reg_flags = flags_bak;
    /* Ready for scheduling */
    current_node->status = PROC_NODE_NEW;
    current_node++;




    /* Set all other process nodes to be unused so that they will not
    be scheduled */
    for(i = 3;i < num_slot;i++)
    {
        current_node->status = PROC_NODE_UNUSED;
        current_node++;
    }
    /* Set current process to be the idle process */
    current_proc = 0;
    /* Move the available system memory pointer */
    sys_mem_avail += total;

    return total;
}
