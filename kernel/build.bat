@echo off
del *.obj
del *.asm
del *.log
del *.com
del *.exe
del .\obj\*.obj
del .\obj\*.asm
del .\obj\*.log
..\build\tcc.exe -B -mc -nobj kernel.c >> .\obj\tcc_kernel.log
..\build\tasm.exe .\obj\kernel.asm, .\obj\kernel.obj; >> .\obj\tasm_kernel.log

..\build\tcc.exe -B -mc -nobj print.c >> .\obj\tcc_print.log
..\build\tasm.exe .\obj\print.asm, .\obj\print.obj; >> .\obj\tasm_print.log

..\build\tcc.exe -B -mc -nobj video.c >> .\obj\tcc_video.log
..\build\tasm.exe .\obj\video.asm, .\obj\video.obj; >> .\obj\tasm_video.log

..\build\tcc.exe -B -mc -nobj mem.c >> .\obj\tcc_mem.log
..\build\tasm.exe .\obj\mem.asm, .\obj\mem.obj; >> .\obj\tasm_mem.log

..\build\tcc.exe -B -mc -nobj process.c >> .\obj\tcc_process.log
..\build\tasm.exe .\obj\process.asm, .\obj\process.obj; >> .\obj\tasm_process.log

..\build\tcc.exe -B -mc -nobj error.c >> .\obj\tcc_error.log
..\build\tasm.exe .\obj\error.asm, .\obj\error.obj; >> .\obj\tasm_error.log

..\build\tcc.exe -B -mc -nobj io.c >> .\obj\tcc_io.log
..\build\tasm.exe .\obj\io.asm, .\obj\io.obj; >> .\obj\tasm_io.log

..\build\tcc.exe -B -mc -nobj timer.c >> .\obj\tcc_timer.log
..\build\tasm.exe .\obj\timer.asm, .\obj\timer.obj; >> .\obj\tasm_timer.log

..\build\tcc.exe -B -mc -nobj syscall.c >> .\obj\tcc_syscall.log
..\build\tasm.exe .\obj\syscall.asm, .\obj\syscall.obj; >> .\obj\tasm_syscall.log

..\build\doslnk.exe /TINY .\obj\kernel.obj .\obj\print.obj .\obj\video.obj .\obj\mem.obj .\obj\process.obj .\obj\error.obj .\obj\io.obj .\obj\timer.obj .\obj\syscall.obj, kernel.com, kernel.map; >> .\obj\doslnk.log