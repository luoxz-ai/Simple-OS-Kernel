
/* The next available pointer to the system static memory.
Increment only */
extern unsigned char far *sys_mem_avail;

extern unsigned char far *video_char_ptr;
asm video_char_segment equ word ptr video_char_ptr + 2
extern unsigned short video_mode;
extern unsigned short current_col;
extern unsigned short current_row;
extern unsigned short total_col;
extern unsigned short total_row;
extern unsigned short start_col;
extern unsigned short start_row;

/* This value is updated dynamically with the current_col and current_row */
/* Try to manage the consistency */
extern unsigned short current_offset;
extern unsigned char cursor_char;
extern unsigned char cursor_mode;
extern unsigned char under_cursor_char;
extern unsigned char under_cursor_mode;
extern unsigned char default_mode;

extern char digit_table[];
extern char equal_16[];

/* From print.c */
int PutChar(unsigned char ch);
int PutString(unsigned char far *str);
int PrintByteHex(unsigned char hex);
int PrintShortHex(unsigned short hex);
int PrintLongHex(unsigned long hex);
int PrintUnsignedShortDec(unsigned short dec);
int PrintSignedShortDec(short dec);
int PrintUnsignedLongDec(unsigned long decimal);
int PrintSignedLongDec(long decimal);
int PrintShortBinary(unsigned short bin);
int PrintLongBinary(unsigned long bin);
int Printf(const char near *str,...);

/* From mem.c */
int SegmentCopy(unsigned short segment,void near *dest,void near *src,unsigned short length);
int SegmentSet(void far *mem,unsigned short bytes,unsigned short length);
int SegmentSetWord(void far *mem,unsigned short words,unsigned short length);
int MemoryCopy(void far *dest,void far *src,unsigned short length);
unsigned long AddressCompare(void far *a1,void far *a2);
unsigned short DetectLowMemory();
unsigned long DetectHighMemory(void far *buffer,unsigned long saved_ebx);
int PrintAllMemory();
int PrintMemoryMap();
int InitMemoryTable(int num_slot);
unsigned short MarkMemoryBlock(unsigned long start_address,unsigned long length,unsigned short owner);
unsigned short UnmarkMemoryBlock(unsigned short slot);
int PrintMemoryTable();
int PrintMemoryNode();
unsigned char far *MemoryAllocation(unsigned long block_size);
unsigned short MemoryFree(void far *mem_block);

/* From video.c */
int InitVideo(unsigned char mode);
unsigned short GetVideoMode();
unsigned short GetNextColumn();
unsigned short GetNextRow();
unsigned short GetPreviousRow();
unsigned short GetPreviousColumn();
unsigned short GetVideoOffset(unsigned short row,unsigned short col);
int CopyLine(unsigned short dest,unsigned short src);
int ClearLine(unsigned short dest,unsigned short fill);
int VideoScrollUp(unsigned short num);
int GoNextPosition();
int GoPreviousPosition();
int GoNextRow();
int GoFirstColumn();
int UnDrawCursor();
int DrawCursor();
int MoveCursor();
unsigned char far *GetVideoPointer();
int ClearScreen(unsigned short start_row_val,unsigned short start_col_val,
                unsigned short total_row_val,unsigned short total_col_val,
                unsigned char default_mode_val);

/* From error.c */
extern unsigned short last_error;
void FatalError(char far *err_str);

/* From io.c */
void OutByte(unsigned short port,unsigned char o_byte);
unsigned char InByte(unsigned short port);
void MaskIRQ(unsigned short irq);
void UnmaskIRQ(unsigned short irq);
void SetInterrupt(unsigned char int_num,void far *address);
unsigned char far *GetInterrupt(unsigned char int_num);

/* From process.c */
extern unsigned short current_proc;
int InitProcessTable(unsigned short proc_slot_num);
void Schedule();
void SaveContext();

/* From syscall.c */
void int80h();
int InitSystemCall();

typedef struct
{
    unsigned short reg_ax; /* 0 */
    unsigned short reg_bx; /* 2 */
    unsigned short reg_cx; /* 4 */
    unsigned short reg_dx; /* 6 */
    unsigned short reg_si; /* 8 */
    unsigned short reg_di; /* 10 */
    unsigned short reg_sp; /* 12 */
    unsigned short reg_bp; /* 14 */

    unsigned short reg_cs; /* 16 */
    unsigned short reg_ip; /* 18 */

    unsigned short reg_ds; /* 20 */
    unsigned short reg_es; /* 22 */
    unsigned short reg_ss; /* 24 */

    unsigned short reg_flags; /* 26 */

    /* 0: Just created
       1: Running
       2: Blocked
       3: Exited
      -1: Not used */
    int status;
} ProcessNode;

#define PROC_NODE_NEW     0
#define PROC_NODE_RUNNING 1
#define PROC_NODE_BLOCKED 2
#define PROC_NODE_EXITED  3
#define PROC_NODE_UNUSED -1


/* constants to test the status flag of the MemoryNode struct */
#define MEM_NODE_ALLOCATED 0x0001
#define MEM_NODE_USED      0x0002

typedef struct
{
    /* 20 bit real mode address or 32 bit protected mode address */
    unsigned long start_address;
    unsigned long end_address;
    /* 0 = system, 1 = user */
    unsigned short owner;
    /* The index of the next node in the linked list */
    /* 0xFFFF if at the end of the list */
    unsigned short next;
    /* The previous node */
    unsigned short prev;
    /* bit 0: 0 = free, 1 = allocated */
    /* bit 1: 0 = not used, 1 = used */
    unsigned short status;

} MemoryNode;

