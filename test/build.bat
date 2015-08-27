del *.obj
del *.asm
del *.log
del *.com
del *.exe
..\build\tcc.exe -S -mt test.c >> .\tcc.log
..\build\tasm.exe test.asm >> .\tasm.log
..\build\doslnk.exe /TINY test.obj, test.com; >> .\doslnk.log