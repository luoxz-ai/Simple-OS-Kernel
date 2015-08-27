del *.obj
del *.asm
del *.log
del *.com
del *.exe
..\build\tcc.exe -S -mt loader.c >> .\tcc.log
..\build\tasm.exe loader.asm >> .\tasm.log
..\build\doslnk.exe /TINY loader.obj, loader.com; >> .\doslnk.log