# Lab Helper Scripts

There are 3 scripts which will help allow the user to get around the lab files much quicker.
No more long cd/cp commands.

To setup, you need to
1. download/copy the setup script into your terminal (Should have the name "fullSetup.sh")
  - copy the [download link](https://github.com/loganmacdougall/Useful-2122-Scripts/raw/main/fullSetup.sh) to fullSetup.sh (right-click -> copy link address)
  - go into timberlea and type "wget ", paste the link and click enter
  - type "chmod 755 fullSetup.sh" to make it runnable
2. set the 3 variables which are close to the top of the script
  - for `LABSFOLDER`, you need to set it to the absolute path of your labs folder
  - for `LIBSFOLDER`, you need to set it to the absolute path of your lib folder. If you don't have one, you should make one.
     - To find both of these, just go into either folder and type "pwd"
  - For `LABPREFIX`, you will put the prefix for all your labs (ex: if the folders are called 2122Lab_01, 2122Lab_02, 2122Lab_03, ... then the prefix would be "2122Lab_")
3. run the setup script
4. logout and log back in

Now everything should work without anymore hassle and the setup script can be deleted.

You can see what each of the 3 scripts do by going into the .bin folder newly created in your terminal and reading the comments

# autoObjDump

Will automatically show you the assembly instructions for your
C code as soon as the code has been modified

This is done by checking when the file has when modified, when the
file is modified, delete the old compiled .o file, recompile the
new .o file, and run "objdump -d" on it

If compiling is unsuccesful, it will print the
gcc compiler errors instead

USAGE:
``./autoObjDump CFILE_EXCLUDING_EXTENSION (0-3)``

EXAMPLE:
For c-file "test.c" at opLevel 2, you would type:
``./autoObjDump test 2``

The best way to use this is to have 2 seprate terminals open at once (one to edit your file and the second to view the assembly code using the autoObjDump program)
