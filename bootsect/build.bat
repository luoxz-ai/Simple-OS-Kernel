del *.obj
del *.com
del *.log
..\build\tasm.exe bootsect.asm >> tasm.log
..\build\doslnk.exe /TINY bootsect.obj,bootsect.com; >> doslnk.log
..\utility\bootsect.exe ..\img\dosboot.ima ..\bootsect\bootsect.com