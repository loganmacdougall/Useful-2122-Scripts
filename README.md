# autoObjDump

Author: Logan MacDougall
Filename: autoObjDump.c

Will automatically show you the assembly instructions for your
C code as soon as the code has been modified

This is done by checking when the file has when modified, when the
file is modified, delete the old compiled .o file, recompile the
new .o file, and run "objdump -d" on it

If compiling is unsuccesful, it will print the
gcc compiler errors instead

USAGE:
./autoObjDump CFILE_EXCLUDING_EXTENSION (0-3)

EXAMPLE:
For c-file "test.c" at opLevel 2, you would type:       ./autoObjDump test 2
