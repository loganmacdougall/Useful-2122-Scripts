/*
    Author: Logan MacDougall
    Filename: autoObjDump.c

    Will automatically show you the assembly instructions for your
    C code as soon as the code has been modified

    This is done by checking when the file has when modified, when the
    file is modified, delete the old compiled .o file, recompile the
    new .o file, and run "objdump -d" on it

    If compiling is unsuccesful, it will print the
    gcc compiler errors instead

    USAGE: ./autoObjDump CFILE_EXCLUDING_EXTENSION (0-3)

    EXAMPLE:
        For c-file "test.c" at opLevel 2, you would type:
                ./autoObjDump test 2
*/

#include<stdio.h>
#include<sys/stat.h>
#include<string.h>
#include<stdlib.h>
//This library doesn't work in windows
#include<unistd.h>

void printObjDump(char* filename, char* outputName, int opLevel);

//Setup and continues to check if a modification has been made
int main(int argc, char** argv) {
    if (argc < 3) {
        printf("Please provide the name of a C file (exclude the .c)\nAs well as the level of optimization\n");
        return 0;
    }

    // ex: filename = example.c
    int filenameSize = sizeof(char) * (strlen(argv[1]) + 3);
    char* filename = malloc(filenameSize);
    memcpy(filename, argv[1], filenameSize);
    strcat(filename, ".c");

    // ex: outputName = example.o
    char* outputName = malloc(filenameSize);
    memcpy(outputName, argv[1], filenameSize);
    strcat(outputName, ".o");

    // opLevel is the level of optimization of the compiler
    char* opPtr;
    int opLevel = strtol(argv[2], &opPtr, 10);
    if (opLevel > 3 || opLevel < 0) {
        printf("Op level must be between 0 and 3\n");
        return 0;
    }

    //Will check if the code has been modified
    //If it has been, print out the objDump
    struct stat filestat;
    stat(filename, &filestat);
    long modifiedTime = filestat.st_mtime;
    printObjDump(filename, outputName, opLevel);
    while(1) {
        sleep(0.1);
        stat(filename, &filestat);
        if (filestat.st_mtime != modifiedTime) {
            modifiedTime = filestat.st_mtime;
            printObjDump(filename, outputName, opLevel);
        }
    }

    //This will never be reached
    free(filename);
    return 0;
}

//Will remove the old .o, recompile, and print the objDump
void printObjDump(char* filename, char* outputName, int opLevel) {
    char *rmexeCommand, *gccCommand, *objdumpCommand;

    int flen = strlen(filename);
    int olen = strlen(outputName);

    //Creates space for the command strings
    rmexeCommand = malloc(sizeof(char) * (5 + olen));
    gccCommand = malloc(sizeof(char) * (24 + olen + flen));
    objdumpCommand = malloc(sizeof(char) * (15 + olen));

    //Creates the command strings
    sprintf(rmexeCommand, "rm %s", outputName);
    sprintf(gccCommand, "gcc -g -O%d -c %s -o %s",opLevel, filename, outputName);
    sprintf(objdumpCommand, "objdump -d %s", outputName);

    char* howToExit = "\nTo exit, press CTRL + C\n";

    //If compiled correctly, print the objdump
    //else, keep the compiler errors
    system(rmexeCommand);
    system("clear");
    printf("%s",howToExit);
    system(gccCommand);
    if (access( outputName, F_OK ) == 0) {
        system("clear");
        printf("%s",howToExit);
        system(objdumpCommand);
    }

    free(rmexeCommand);
    free(gccCommand);
    free(objdumpCommand);
}