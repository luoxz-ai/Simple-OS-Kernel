
#include "..\include\basic.h"

asm .486p

void PrintShortHex(unsigned short hex);
void PrintFileName();
void ReadFile();
void ReadClusters(unsigned char far *file_entry);
void PrintString(char near *str);
void ReadSector(unsigned short sector_id,unsigned short read_num,unsigned short sector_per_track,
                unsigned short num_head, unsigned char device_id,void far *addr);
void SwitchTo4GB();

void main()
{
    unsigned short cs_value;
    char near *cs_value_str_ptr;
    char near *crlf_ptr;
    asm mov si, cs
    asm mov ds, si
    asm mov cs_value, si
    asm xor si, si
    asm mov es, si
    asm assume ds:_TEXT, es:nothing
    asm mov cs_value_str_ptr, offset cs_value_str
    asm mov crlf_ptr, offset crlf
    SwitchTo4GB();
    PrintString(cs_value_str_ptr);
    PrintShortHex(cs_value);
    PrintString(crlf_ptr);
    ReadFile();
    while(1);
}

void SwitchTo4GB()
{
    asm push ds
    asm push es
    /* eax = data segment linear address */
    asm xor eax, eax
    asm mov ax, ds
    asm shl eax, 4
    /* Base + offset gdt = Linear address of label gdt */
    asm add eax, offset gdt
    asm mov dword ptr [gdt_ptr + 2], eax
    asm cli
    asm lgdt qword ptr [gdt_ptr]
    asm mov eax, cr0
    asm or al, 1
    asm mov cr0, eax
    asm mov bx, ds_descriptor
    asm mov ds, bx
    asm mov es, bx
    asm mov fs, bx
    asm mov gs, bx
asm SwitchTo4GB_next:
    asm dec al
    asm mov cr0, eax
    asm pop es
    asm pop ds
    return;

    asm gdt label byte
    asm dw 0
    asm dw 0
    asm db 0
    asm db 0
    asm db 0
    asm db 0
    asm ds_descriptor equ $ - offset gdt
    asm dw 0FFFFh
    asm dw 0
    asm db 0
    asm db 92h
    asm db 0CFh
    asm db 0
    asm gdt_end label byte
    asm gdt_ptr label
    asm dw offset gdt_end - offset gdt
    asm dd 0
}

/* This print string uses near pointer */
void PrintString(char near *str)
{
    asm mov si, str
    asm cld
print_string_loop:
    asm lodsb
    asm mov ah, 0eh
    asm cmp al, 0
    asm jz print_string_ret
    asm xor bx, bx
    asm mov bl, 07h
    asm int 10h
    asm jmp print_string_loop
print_string_ret:
    return;
}

int Error(unsigned short code)
{
    char near *error_str_ptr;
    char near *crlf_ptr;
    asm mov error_str_ptr, offset error_str
    asm mov crlf_ptr, offset crlf
    PrintString(error_str_ptr);
    PrintShortHex(code);
    PrintString(crlf_ptr);
    while(1);
}

void null()
{
    asm digit_table db '0123456789ABCDEF'
    asm kernel_filename db 'KERNEL  COM'
    asm crlf db 0dh, 0ah, 0
    asm cs_value_str db 'Code Segment = ',0
    asm error_str db 'Fatal Error, Code = ',0
}

/* Given a cluster number (start from 2) return the FAT sector offset (start from 0) */
/* so that we can read the FAT for this cluster and find the next cluster. */
unsigned short GetNextCluster(unsigned int cluster_num,unsigned short fat_start,unsigned short spt,
                            unsigned short nh, unsigned short di)
{
    /* We read the FAT sectors into 0000:1600 which is very close to the IVT */
    unsigned char far *FAT = LOADER_FAT_ADDRESS;
    unsigned int three_byte_offset = cluster_num / 2;
    unsigned int byte_offset = three_byte_offset * 3;
    /* 0 = Low 12 bit; 1 = High 12 bit */
    unsigned char low_high = cluster_num % 2;
    unsigned int start_byte_sector = byte_offset / 512;
    unsigned int end_byte_sector = (byte_offset + 2) / 512;
    unsigned int start_byte_offset = byte_offset % 512;
    unsigned short read_num;
    unsigned short FAT_entry_low, FAT_entry_high;
    unsigned short FAT_entry_16;
    /* If the three byte is in the same sector */
    if(start_byte_sector == end_byte_sector) read_num = 1;
    else read_num = 2;

    ReadSector(start_byte_sector + fat_start,read_num,spt,nh,di,FAT);

    FAT_entry_low = ((unsigned short far *)(FAT + start_byte_offset))[0];
    FAT_entry_high = ((unsigned short far *)(FAT + start_byte_offset))[1];
    if(low_high == 0) FAT_entry_16 = FAT_entry_low & 0x0FFF;
    else FAT_entry_16 = (FAT_entry_low >> 12) | ((FAT_entry_high & 0x00FF) << 4);
    return FAT_entry_16;
}

void ReadSector(unsigned short sector_id,unsigned short read_num,unsigned short sector_per_track,
                unsigned short num_head, unsigned char device_id,void far *addr)
{
    unsigned short track_id = sector_id / (sector_per_track * num_head);
    unsigned short head_id = (sector_id / sector_per_track) % num_head;
    sector_id = (sector_id % sector_per_track) + 1;
    if(track_id > 127 || head_id > 127 || sector_id > 127 || read_num > 127) Error(0xFFFF);
    asm push es
    asm push bx
    asm mov al, byte ptr read_num
    asm mov ch, byte ptr track_id
    asm mov cl, byte ptr sector_id
    asm mov dh, byte ptr head_id
    asm mov dl, byte ptr device_id
    asm mov ah, 02h
    asm les bx, addr
    asm int 13h
    asm jc report_error
    asm pop bx
    asm pop es
    return;
report_error:
    Error(0xFFFE);
}

void ReadClusters(unsigned char far *file_entry)
{
    unsigned short current_cluster = file_entry[0x1A];
    unsigned char far *boot_sect = 0x00007C00;
    unsigned short sector_per_track = ((unsigned short far *)(boot_sect + 24))[0];
    unsigned short num_head = ((unsigned short far *)(boot_sect + 26))[0];
    unsigned short fat_sector = ((unsigned short far *)(boot_sect + 22))[0];
    unsigned char num_fat = ((unsigned char far *)(boot_sect + 16))[0];
    unsigned short reserved_sector = ((unsigned short far *)(boot_sect + 14))[0];
    unsigned long hidden_sector = ((unsigned long far *)(boot_sect + 28))[0];
    unsigned short dir_entry_num = ((unsigned short far *)(boot_sect + 17))[0];
    unsigned char sector_per_cluster = ((unsigned char far *)(boot_sect + 13))[0];
    unsigned char device_id = ((unsigned char far *)(boot_sect + 36))[0];
    unsigned short byte_per_sector = 512;
    unsigned short entry_size = 0x20;
    /* We use the longest among all of these. */
    /* These two are the logical sector number, which starts at 0, not 1 */
    unsigned long dir_start = hidden_sector + reserved_sector + num_fat * fat_sector;
    unsigned long data_start = dir_start + ((dir_entry_num * entry_size) + byte_per_sector - 1) / byte_per_sector;
    unsigned long fat_start = hidden_sector + reserved_sector;
    unsigned short current_sector;
    /* The kernel will be loaded to 7000:0000 */
    unsigned char far *kernel_addr = SYS_CODE_PTR;
    int load_count = 0;

    /*
    unsigned short far *test = 0x10000000;
    ReadSector(fat_start,1,sector_per_track,num_head,device_id,test);
    */
    /* Error(*test); */
    if(current_cluster == 0x0000) Error(0xFFFC);
    while(current_cluster != 0x0FFF)
    {
        current_sector = (current_cluster - 2) * sector_per_cluster;
        ReadSector(current_sector + data_start,sector_per_cluster,sector_per_track,num_head,device_id,kernel_addr + 512 * load_count);
        current_cluster = GetNextCluster(current_cluster,fat_start,sector_per_track,num_head,device_id);
        load_count++;
    }
    /* Jump to the kernel code */
    asm jmp dword ptr [kernel_addr]

    return;
}

void ReadFile()
{
    unsigned char far *addr = 0x00000000;
    unsigned char far *file_entry = addr + 0x500;
    char near *file_name;
    int i,j;
    char chr;

    asm mov file_name, offset kernel_filename
    for(i = 0;i < 512 / 0x20;i++)
    {
        if(file_entry[0] == 0) break;
        for(j = 0;j < 11;j++)
        {
            if(file_entry[j] != file_name[j]) break;
        }
        /* PrintShortHex(j); */
        if(j == 11) ReadClusters(file_entry);
        else file_entry += 0x20;
    }
    Error(0xFFFD);
}
/*
void PrintFileName()
{
    unsigned char far *addr = 0x00000000;
    unsigned char far *file_entry = addr + 0x500;
    int i,j;
    char chr;
    for(i = 0;i < 512 / 0x20;i++)
    {
        if(file_entry[0] == 0) return;
        for(j = 0;j < 11;j++)
        {
            chr = file_entry[j];
            asm push ax
            asm push bx
            asm mov ah, 0eh
            asm mov al, chr
            asm xor bx, bx
            asm mov bl, 07h
            asm int 10h
            asm pop bx
            asm pop ax
        }
        file_entry += 0x20;
    }
}
*/

/*
void PrintFileName()
{
    asm mov bx, 500h
    asm mov cx, 11d
    asm mov ax, 512d
    asm mov dl, 20h
    asm div dl
    asm xor ah, ah

print_file_name_loop:
    asm cmp byte ptr es:[bx], 0
    asm je retr
    asm push ax
    asm mov cx, 11d
    asm xor si, si
print_char_loop:
    asm mov al, es:[bx + si]
    asm mov ah, 0eh
    asm push bx
    asm xor bx, bx
    asm mov bl, 07h
    asm int 10h
    asm pop bx

    asm dec cx
    asm inc si
    asm cmp cx, 0
    asm jnz print_char_loop

    asm mov ah, 0Dh
    asm int 10h
    asm mov ah, 0Ah
    asm int 10h

    asm pop ax
    asm dec ax
    asm cmp ax, 0
    asm jz retr
    asm add bx, 20h
    asm jmp print_file_name_loop
retr:
    return;
}
*/

void PrintShortHex(unsigned short hex)
{
    asm push ax
    asm push bx
    asm push cx
    asm mov cx, 12d
print_hex_loop:
    asm mov ax, hex
    asm shr ax, cl
    asm sub cx, 4
    asm and ax, 0Fh
    asm mov bx, ax
    asm mov al, byte ptr [offset digit_table + bx]
    asm mov ah, 0eh
    asm xor bx, bx
    asm mov bl, 07h
    asm int 10h

    asm cmp cx, 0
    asm jge print_hex_loop

    asm pop cx
    asm pop bx
    asm pop ax
}
