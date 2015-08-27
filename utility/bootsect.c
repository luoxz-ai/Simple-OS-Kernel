
#include <stdio.h>
#include <string.h>

void main(int argc,char **argv)
{
    char image_name[128];
    char sect_name[128];
    unsigned char buffer[512];
    FILE *fp_image,*fp_sect;


    if(argc == 1)
    {
        printf("Please input the name of the image file: ");
        scanf("%s",image_name);
        printf("Please input the name of the bootsect file: ");
        scanf("%s",sect_name);
    }
    else if(argc == 2)
    {
        printf("Please input the name of the bootsect file: ");
        scanf("%s",sect_name);
        /* The only parameter is assumed to be the image file */
        strcpy(image_name,argv[1]);
    }
    else
    {
        strcpy(image_name,argv[1]);
        strcpy(sect_name,argv[2]);
    }

    fp_image = fopen(image_name,"rb+");
    fp_sect = fopen(sect_name,"rb+");
    if(fp_image == NULL || fp_sect == NULL)
    {
        printf("Error: Cannot open file %s\n",!fp_image? image_name : sect_name);
        getchar();
    }
    fseek(fp_sect,0x7C00,SEEK_SET);
    fread(buffer,512,1,fp_sect);
    fwrite(buffer,512,1,fp_image);

    fclose(fp_sect);
    fclose(fp_image);

    return;
}
