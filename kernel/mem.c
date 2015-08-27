
#define WINDEBUG

#ifndef _WINDEBUG
#include "..\include\basic.h"
#include "..\include\kernel.h"
#else
#include <stdio.h>
#endif
asm _DATA ends
asm _TEXT segment byte public 'CODE'

asm .486
asm .MODEL TINY

/* Size of the basic memory (usually from 0x00000 - 640K) */
unsigned short basic_mem_size = 0x0000;
/* The number of memory nodes */
unsigned short mem_slot_num = 0x0000;
unsigned short mem_slot_remain = 0x0000;
/* The far pointer to the start address of system data area (usually the next
segment of the code & stack segment */
MemoryNode far *sys_mem_ptr = 0x00000000;
char mem_slot_full_msg[] = "Memory Slot Full.";

asm _TEXT ends
asm _DATA segment word public 'DATA'

/* Compares the first parameter with the second parameter
The return value is a long integer in DX:AX. It is the difference
of the first parameter and the second parameter. So if the return value is
positive then then the first address is larger, or else the second is larger.
And if the return value is 0 then the two addresses are the same. */
unsigned long AddressCompare(void far *a1,void far *a2) /* public */
{
    unsigned char bit32[4];
    /* Clear eax and ebx */
    asm xor eax, eax
    asm mov ebx, eax
    /* Load the high 16 bits, the segment address */
    asm mov ax, [a1 + 2]
    asm mov bx, [a2 + 2]
    asm shl eax, 4
    asm shl ebx, 4
    /* Make the segment address 0, we only want to add the 32bit offset */
    asm xor cx, cx
    asm mov [a1 + 2], cx
    asm mov [a2 + 2], cx
    /* Add the 32-bit offset (we cannot use 16 bit offset) */
    asm add eax, a1
    asm add ebx, a2
    /* Take the difference */
    asm sub eax, ebx
    /* Load dx:ax using local variable */
    asm mov bit32, eax
    /* DX is the high 16 bit and ax is the low 16 bit */
    asm mov dx, [bit32 + 2]
    asm mov ax, [bit32]
    return;
}

/* return +1 if m1 > m2 (unsigned)
          -1 if m1 < m2
           0 if m1 = m2 */
int ULCompare(unsigned long m1,unsigned long m2)
{
    asm mov eax, m1
    asm mov ebx, m2
    asm sub eax, ebx
    asm ja UnsignedLongCompare_above
    asm jb UnsignedLongCompare_below
    return 0;
UnsignedLongCompare_above:
    return 1;
UnsignedLongCompare_below:
    return -1;
}

/* Simulates 32 bit addition using 32 bit instructions
flags are preserved after returning */
unsigned long ULAddition(unsigned long op1,unsigned long op2)
{
    unsigned long result;
    asm mov eax, op1
    asm mov ebx, op2
    asm add eax, ebx
    asm mov result, eax
    asm mov dx, [result + 2]
    /* DX:AX is the long number */
    return;
}

int MemoryCopy(void far *dest,void far *src,unsigned short length) /* public */
{
    asm push es
    asm push ds
    asm push si
    asm push di

    asm lds si, src
    asm les di, dest

    /* dest is the first argument */
    asm push dword ptr src
    asm push dword ptr dest
    asm call AddressCompare
    asm add sp, 8
    /* CX stays valid after calling the function */
    asm mov cx, length
    /* The return value is in DX:AX, just check the sign bit in DX to see if
    the result is a negative or positive */
    asm test dx, dx
    /* If the sign bit is not set (positive) then destination is bigger just jump */
    asm jns MemoryCopy_high2low
    asm cld
    asm jmp MemoryCopy_start
MemoryCopy_high2low:
    asm std
    asm dec word ptr length
    asm add si, length
    asm add di, length
MemoryCopy_start:
    asm rep movsb

    asm pop di
    asm pop si
    asm pop ds
    asm pop es

    return length;
}

/* memcpy for the kernel, this is a far procedure,
However, the range must lie within 64kb
Also we do check the overlap, but the pointer must not exceed segment limit */
int SegmentCopy(unsigned short segment,
                void near *dest,void near *src,unsigned short length) /* public */
{
    asm push word ptr length
    asm push word ptr segment
    asm push word ptr src
    asm push word ptr segment
    asm push word ptr dest
    asm call MemoryCopy
    asm add sp, 10
    return;
}

/* Initialize a memory block with a given byte value
This is the same as MemorySet, since we do not need a 32-bit address */
int SegmentSet(void far *mem,unsigned short bytes,unsigned short length) /* public */
{
    asm push di
    asm push es
    asm les di, mem
    asm mov al, byte ptr bytes
    asm mov cx, length
    asm cld
    asm rep stosb
    asm pop es
    asm pop di
    return;
}

/* Same as SegmentSet except that we are dealing with word length.
The length is the number of words, rather than the number of total bytes */
int SegmentSetWord(void far *mem,unsigned short words,unsigned short length) /* public */
{
    asm push di
    asm push es
    asm les di, mem
    asm mov ax, word ptr words
    asm mov cx, length
    asm cld
    asm rep stosw
    asm pop es
    asm pop di
    return;
}

/* The return value is the nunber of memory available from 0 - upper
which is represented in KB */
unsigned short DetectLowMemory() /* public */
{
    asm xor ax, ax
    asm int 12h
    asm jc DetectLowMemory_error
    asm test ax, ax
    asm jz DetectLowMemory_error
    /* Save the value in the global variable basic_mem_size */
    asm mov basic_mem_size, ax
    return;
DetectLowMemory_error:
    /* Set ax = -1 and return */
    asm xor ax, ax
    asm dec ax
    return;
}

unsigned long DetectHighMemory(void far *buffer,unsigned long saved_ebx) /* public */
{
    unsigned long next_ebx;
    asm push es
    asm push di

    asm les di, buffer
    asm xor eax, eax
    asm mov edx, 534D4150h
    asm mov ax, 0E820h
    asm mov ecx, 24
    asm mov ebx, saved_ebx
    asm int 15h
    asm cmp eax, 534D4150h
    asm jnz DetechHighMemory_error
    asm jc DetechHighMemory_error
    /* Save EBX */
    asm mov next_ebx, ebx
    /* Low 16 bits go into AX */
    asm mov ax, bx
    /* High 16 bits go into DX */
    asm mov dx, [next_ebx + 2]

    asm pop di
    asm pop es
    return;
DetechHighMemory_error:
    asm xor ax, ax
    asm dec ax
    asm mov dx, ax
    asm pop di
    asm pop es
    return;
}

/* Prints the memory map.
Returns 0 if successful, -1 if fail */
int PrintMemoryMap() /* public */
{
    unsigned long saved_ebx = 0x00000000;
    unsigned char mem_map[24];
    char sep[4];
    sep[0] = ' ';
    sep[1] = '|';
    sep[2] = ' ';
    sep[3] = '\0';
    Printf("%s\n= Memory Map\n%s\n",(char far *)equal_16,(char far *)equal_16);
    PutString("Base Address     | Length           | Type\n");
    do
    {
        saved_ebx = DetectHighMemory(mem_map,saved_ebx);
        if(saved_ebx == -1) return -1;
        PrintLongHex(((unsigned long *)(mem_map +  4))[0]);
        PrintLongHex(((unsigned long *)(mem_map +  0))[0]);
        PutString(sep);
        PrintLongHex(((unsigned long *)(mem_map + 12))[0]);
        PrintLongHex(((unsigned long *)(mem_map +  8))[0]);
        PutString(sep);
        PrintLongHex(((unsigned long *)(mem_map + 16))[0]);
        PutChar('\n');
    }while(saved_ebx != 0);
    return 0;
}

MemoryNode far *GetMemoryNode(unsigned short index)
{
    return ((MemoryNode far *)sys_mem_ptr) + index;
}

int PrintAllMemory() /* public */
{
    unsigned short low_mem = DetectLowMemory();
    Printf("Detecting basic memory...INT 15H - %dKBytes\n",low_mem);
    return PrintMemoryMap();
}

/* Returns the index of an unused slot. Returns 0xFFFF if not found
Also it will change the number of available nodes. So if you have found a node
but do not want to use it then remember to call another function to make it
available again. */
unsigned short FindUnusedMemoryNode()
{
    MemoryNode far *mem_node = (MemoryNode far *)sys_mem_ptr;
    int i;

    for(i = 0;i < mem_slot_num;i++)
    {
        if(!(mem_node->status & MEM_NODE_USED))
        {
            mem_slot_remain--;
            mem_node->status |= MEM_NODE_USED;
            return i;
        }
        mem_node++;
    }
    return 0xFFFF;
}

/* Free a used memory node to unused - this doesn't deal with allocated or not
This function will change mem_slot_remain, so use this one instead of doing
your own job */
int AddUnusedMemoryNode(unsigned short slot)
{
    MemoryNode far *mem_node = (MemoryNode far *)sys_mem_ptr;
    (mem_node + slot)->status &= (~MEM_NODE_USED);
    mem_slot_remain++;
    return 0;
}

/* Given a start address, find a block of memory which satisfieds the start address and the length
and allocate it using a dual directional linked list.
The return value is the slot of the allocated node, or 0xFFFF if no such a block is found.
If the memory slots are all full then it will report a fatal error and the kernel will just crash */
unsigned short MarkMemoryBlock(unsigned long start_address,unsigned long length,unsigned short owner) /* public */
{
    /* Base pointer */
    MemoryNode far *mem_node = ((MemoryNode far *)sys_mem_ptr);
    /* These two are used to record the current node, which will be splited */
    MemoryNode far *current_node = mem_node;
    /* We always start from slot 0 */
    unsigned short current_slot = 0;
    /* After spliting we will have at most 3 nodes */
    MemoryNode far *before_node;
    MemoryNode far *after_node;
    /* Used as a temporary var to hold the new node number */
    unsigned short new_slot_before;
    unsigned short new_slot_after;
    /* The end address of the requested block */
    unsigned long range_end_address;
    /* Flags for UL comparison */
    int cmp_end,cmp_start;
    /* Kernel can allocate memory for any other process, and besides that no process
    can allocate memory for other process */
    if(current_proc != 0x0000 && owner != current_proc) return 0xFFFF;

    do
    {
        current_slot = current_node->next;
        current_node = mem_node + current_node->next;
        /* range_end_address is the end address of the block (exactly) */
        range_end_address = ULAddition(ULAddition(start_address,length),-1L);
        /* The requested block can fit into the free block */
        cmp_end = ULCompare(current_node->end_address,range_end_address);
        cmp_start = ULCompare(start_address,current_node->start_address);
        /* If the block fits */
        if(cmp_start != -1 && cmp_end != -1)
        {
            /* First isolate current_node from its prev and next by changing the pointes */
            if(current_node->next != 0xFFFF) (mem_node + current_node->next)->prev = current_node->prev;
            if(current_node->prev != 0xFFFF) (mem_node + current_node->prev)->next = current_node->next;
            /* We have more memory before the requested block */
            if(cmp_start != 0)
            {
                /* Create a new node */
                new_slot_before = FindUnusedMemoryNode();
                /* If slot full we temporarily make it freeze, but there are better
                solutions. i.e. maybe we can migrate the table to somewhere else */
                if(new_slot_before == 0xFFFF) FatalError(mem_slot_full_msg);
                before_node = mem_node + new_slot_before;
                before_node->start_address = current_node->start_address;
                /* Just 1 byte before the requested address */
                before_node->end_address = ULAddition(start_address,-1);
                before_node->owner = current_node->owner;
                /* This implicitly marks the USED bit */
                before_node->status = current_node->status;
                /* If there is not an after_node then the next is the next of current node */
                before_node->next = current_node->next;
                before_node->prev = current_node->prev;
                /* Modify the node before and after the current_node */
                if(current_node->prev != 0xFFFF) (mem_node + current_node->prev)->next = new_slot_before;
                if(current_node->next != 0xFFFF) (mem_node + current_node->next)->prev = new_slot_before;
                current_node->start_address = start_address;
                current_node->prev = new_slot_before;
            }
            if(cmp_end != 0)
            {
                new_slot_after = FindUnusedMemoryNode();
                if(new_slot_after == 0xFFFF) FatalError(mem_slot_full_msg);
                after_node = mem_node + new_slot_after;
                after_node->start_address = ULAddition(range_end_address,1L);
                after_node->end_address = current_node->end_address;
                after_node->owner = current_node->owner;
                after_node->status = current_node->status;
                after_node->next = current_node->next;
                after_node->prev = current_node->prev;
                /* Modify the node before and after the current_node */
                if(current_node->prev != 0xFFFF) (mem_node + current_node->prev)->next = new_slot_after;
                if(current_node->next != 0xFFFF) (mem_node + current_node->next)->prev = new_slot_after;
                current_node->end_address = range_end_address;
            }
            /* Return the index of the allocated node */
            current_node->next = 0xFFFF;
            current_node->prev = 0xFFFF;
            current_node->status |= MEM_NODE_ALLOCATED;
            current_node->owner = owner;
            return current_slot;
        }
    }while(current_node->next != 0xFFFF);

    return 0xFFFF;
}

unsigned short UnmarkMemoryBlock(unsigned short slot) /* public */
{
    MemoryNode far *mem_node = (MemoryNode far *)sys_mem_ptr;
    MemoryNode far *current_node = mem_node + slot;
    MemoryNode far *iter = mem_node;
    MemoryNode far *temp;
    unsigned short iter_slot,temp_slot;
    /* Used to control the merge */
    int flag = 0;
    int cmp_before,cmp_after;

    /* Cannot free unexist block */
    if(slot >= mem_slot_num) return -1;
    /* Cannot free unused block */
    if((!(mem_node + slot)->status & MEM_NODE_USED)) return -1;

    do
    {
        iter_slot = iter->next;
        iter = (mem_node + iter_slot);
        /* The start_address of the next block must be greater than or
        equal to the current_node->end_address */
        cmp_after = ULCompare(iter->start_address,current_node->end_address);
        if(cmp_after != -1)
        {
            (mem_node + iter->prev)->next = slot;
            current_node->prev = iter->prev;
            iter->prev = slot;
            current_node->next = iter_slot;
            break;
        }
        /* If this is true then current_node is appended to the last */
        else if(iter->next == 0xFFFF)
        {
            iter->next = slot;
            current_node->prev = iter_slot;
            current_node->next = 0xFFFF;
            break;
        }
    }while(1);

    current_node->status &= (~MEM_NODE_ALLOCATED);

    do
    {
        flag = 0;
        if(current_node->prev != 0xFFFF)
        {
            /* Get previous node, we cache the result because we will use it multiple times */
            temp = current_node->prev + mem_node;
            temp_slot = current_node->prev;
            cmp_before = ULCompare(current_node->start_address,ULAddition(temp->end_address,1L));
            /* If they are equal, i.e. the two free blocks are adjacent, we just merge them */
            if(cmp_before == 0)
            {
                flag++;
                current_node->start_address = temp->start_address;
                current_node->prev = temp->prev;
                if(temp->prev != 0xFFFF) (mem_node + temp->prev)->next = slot;
                /* Clear that node */
                AddUnusedMemoryNode(temp_slot);
            }
        }
        if(current_node->next != 0xFFFF)
        {
            /* Get previous node, we cache the result because we will use it multiple times */
            temp = current_node->next + mem_node;
            temp_slot = current_node->next;
            cmp_after = ULCompare(ULAddition(current_node->end_address,1L),temp->start_address);
            /* If they are equal, i.e. the two free blocks are adjacent, we just merge them */
            if(cmp_after == 0)
            {
                flag++;
                current_node->end_address = temp->end_address;
                current_node->next = temp->next;
                /* Special here, since we need to worry about it when temp is the last element
                in the linked list */
                if(temp->next != 0xFFFF) (mem_node + temp->next)->prev = slot;
                AddUnusedMemoryNode(temp_slot);
            }
        }
    }while(flag != 0);

    return 0;
}

/* The memory table lies in the lowest address of the system segment
Return the number of bytes used by the table */
int InitMemoryTable(int num_slot) /* public */
{
    int i;
    unsigned long end_address;
    unsigned short s1, s2;
    MemoryNode far *mem_node;
    unsigned char far *test;
    unsigned short total_bytes;

    /* Initialize the base pointer */
    sys_mem_ptr = (MemoryNode far *)sys_mem_avail;
    mem_node = sys_mem_ptr;

    /* Save the number of slots */
    mem_slot_num = num_slot;

    mem_node->start_address = 0x00000000;
    mem_node->end_address = 0x00000000;
    mem_node->next = 1;
    mem_node->prev = 0xFFFF;
    mem_node->status = 0x0000 | MEM_NODE_USED;
    mem_node++;

    mem_node->start_address = 0x00000500;
    /* The top is basic_mem_size * 1K */
    /* mem_node->end_address = (basic_mem_size << 10) - 1; */
    /* Use 32-bit instruction to get the end address */
    asm xor eax, eax
    asm mov ax, basic_mem_size
    asm shl eax, 10
    asm dec eax
    asm mov end_address, eax
    mem_node->end_address = end_address;
    /* There is not another node yet */
    mem_node->next = 0xFFFF;
    mem_node->prev = 0;
    /* Mark it as used */
    mem_node->status = 0x0000 | MEM_NODE_USED;
    mem_node++;

    /* Initialize the remaining nodes */
    for(i = 2;i < mem_slot_num;i++)
    {
        mem_node->start_address = 0x00000000;
        mem_node->end_address = 0x00000000;
        mem_node->next = 0xFFFF;
        mem_node->prev = 0xFFFF;
        mem_node->status = 0x0000;
        mem_node++;
    }
    /* 64K code */
    s1 = MarkMemoryBlock(0x00070000,0x00010000,0);
    /* 64K data and stack */
    s2 = MarkMemoryBlock(0x00080000,0x00010000,0);
    UnmarkMemoryBlock(s2);
    UnmarkMemoryBlock(s1);
    s1 = MarkMemoryBlock(0x00070000,0x00010000,0);
    s2 = MarkMemoryBlock(0x00080000,0x00010000,0);
    test = MemoryAllocation(0x120);
    MemoryFree(test);
    PrintMemoryTable();
    PrintMemoryNode();

    total_bytes = num_slot * sizeof(MemoryNode);
    /* Move the pointer to next available position */
    sys_mem_avail += total_bytes;
    /* Return total bytes used by the table */
    return total_bytes;
}

/* This function will extract a far pointer from a linear address,
and then fill it to a place given by a far pointer.
If the linear address is larger than 1MB then an incorrect result will be returned.
The offset is guaranteed no more than 0x0F */
unsigned char far *GetFarPointer(unsigned long linear_address)
{
    asm mov eax, linear_address
    /* Low 4 bit offset (0 - 15) and the remaining is the segment address */
    asm mov cx, ax
    asm and cx, 000Fh
    asm shr eax, 4
    /* Low 16 bit offset */
    asm mov dx, ax
    /* High 16 bit segment */
    asm mov ax, cx
    return;
}

/* Allocate a block of memory, with the slot number being the first two bytes
of the block.
Return the remaining part as the allocated memory block. When reclaiming the memory block
we can use the slot number residing at the first two bytes */
unsigned char far *MemoryAllocation(unsigned long block_size) /* public */
{
    MemoryNode far *mem_node = (MemoryNode far *)sys_mem_ptr;
    MemoryNode far *current_node = mem_node;
    unsigned short far *allocated_block;
    unsigned short allocated_slot;
    unsigned long end_address;
    /* Special preparation */
    if(ULCompare(block_size,0L) == 0) return 0x00000000;
    /* We need extra 2 bytes to store the slot number */
    block_size = ULAddition(block_size,sizeof(unsigned short));

    do
    {
        current_node = (mem_node + current_node->next);
        end_address = ULAddition(current_node->start_address,ULAddition(block_size,-1L));
        /* If the block size is larger than the requested size */
        if(ULCompare(current_node->end_address,end_address) != -1)
        {
            /* Allocate a block of memory for the current process */
            allocated_slot = MarkMemoryBlock(current_node->start_address,block_size,current_proc);
            /* If for some very strange reason we get an error */
            if(allocated_slot == 0xFFFF) return 0x00000000;
            else allocated_block = (unsigned short far *)GetFarPointer((mem_node + allocated_slot)->start_address);
            /* Fill in the slot number at the first two bytes */
            allocated_block[0] = allocated_slot;
            /* Return the usable position */
            return (unsigned char far *)(allocated_block + 1);
        }

    }while(current_node->next != 0xFFFF);
    return 0x00000000;
}

unsigned short MemoryFree(void far *mem_block) /* public */
{
    unsigned short far *slot_ptr = (unsigned short far *)mem_block;
    unsigned short slot = *(slot_ptr - 1);
    MemoryNode far *mem_node = (MemoryNode far *)sys_mem_ptr;
    if(slot >= mem_slot_num)
    {
        last_error = 0xFFFF;
        return -1;
    }
    else if(current_proc != 0x0000 && (mem_node + slot)->owner != current_proc)
    {
        last_error = 0xFFFE;
        return -1;
    }
    return UnmarkMemoryBlock(slot);
}

void PrintMemoryTableHead()
{
    Printf("Index\tStart\t\tEnd\t\t\tStatus\tNext\tPrev\n");
    return;
}

void PrintMemoryTableNode(int slot)
{
    MemoryNode far *current_node = GetMemoryNode(slot);
    Printf("%d\t\t%lx\t%lx\t%x\t%d\t\t%d\n",slot,current_node->start_address,current_node->end_address,
            current_node->status,current_node->next,current_node->prev);
    return;
}

int PrintMemoryTable() /* public */
{
    MemoryNode far *mem_node = ((MemoryNode far *)sys_mem_ptr);
    MemoryNode far *current_node = mem_node;
    unsigned short current_slot;
    Printf("%s\n= Memory Table\n%s\n",(char far *)equal_16,(char far *)equal_16);
    PrintMemoryTableHead();
    do
    {
        current_slot = current_node->next;
        current_node = mem_node + current_slot;
        PrintMemoryTableNode(current_slot);
    }while(current_node->next != 0xFFFF);
    return;
}

int PrintMemoryNode() /* public */
{
    MemoryNode far *mem_node = ((MemoryNode far *)sys_mem_ptr);
    int i;
    Printf("%s\n= Memory Node\n%s\n",(char far *)equal_16,(char far *)equal_16);
    PrintMemoryTableHead();
    for(i = 0;i < mem_slot_num;i++)
    {
        if(mem_node->status & MEM_NODE_USED) PrintMemoryTableNode(i);
        mem_node++;
    }
    return;
}

#ifdef _WINDEBUG
void main()
{
    unsigned long saved_ebx = 0;
    unsigned char test[24];
    do
    {
        saved_ebx = DetectHighMemory(test,saved_ebx);
        if(saved_ebx == -1)
        {
            puts("Error");
            break;
        }
        printf("%lx",((unsigned long *)test)[0]);
    }while(saved_ebx != 0);
    getchar();
}
#endif
