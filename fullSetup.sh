#!/bin/bash

# Author: Logan MacDougall
# Filename: fullSetup

# Will setup all scripts in the repository
# except for autoObjDump.c, as that one
# requires no setup

# If this is run multiple times, you may have to
# clean duplicate lines of code in your .profile
# but everything should update cleanly.
#
# This happens because I append to .profile to
# not overwrite important setting where as everything else
# is my own script which is safe to overwrite each time.

#Set the following variables before running
LABSFOLDER=""
LIBSFOLDER=""
LABPREFIX=""

if [ -z "$LABPREFIX" ] || [ -z "$LABSFOLDER" ] || [ -z "$LIBSFOLDER" ]; then
        echo "All 3 variables must be set in this script first"
        head ./fullSetup.sh -n 21 | tail -n 3
        exit 128
fi

cd ~

cat >> .profile << FILE_EOF

### Useful-2122-scripts ###

# These can be changed if you're putting your files in other places
#path to "tp-completion.sh"
PATH_TO_COMPLETIONS="~/.tp-completion.sh"
#path to folder which stores "tp", "libportal", "mkscript"
PATH_TO_SCRIPTS="~/.bin"

# gives the tp command to run as you instead of a program
# this is required so that the tp command can change
# your directory with "cd"
alias tp="source tp"

# Allows the tp command to have auto complete by running this script as source
# and saving the completion script to the current bash session.
source \$PATH_TO_COMPLETIONS

# Path to all of my bash scripts which are able to run without requiring the path
# Ex: to run tp as "tp", the script "tp" must exist in the folder "~/.bin"
export PATH=\$PATH:\$PATH_TO_SCRIPTS

FILE_EOF

cat > .tp-completion.sh << FILE_EOF
#usr/bin/env bash

# Author: Logan MacDougall
# Filename: tp-completion.sh

# This is used along side the tp script so clicking
# the tab key will provide auto-completion

USERNAME=\$(whoami)

# These variables must be set same as they are in the tp file
LABSFOLDER="$LABSFOLDER"
LABPREFIX="$LABPREFIX"

_tp_completions() {
    if [ \${#COMP_WORDS[@]} == 2 ]; then
        COMPREPLY+=(\$(compgen -W "lab lib" "\${COMP_WORDS[1]}"))
        return 0
    else
        case \${COMP_WORDS[1]} in
            "lab")
                if [ \${#COMP_WORDS[@]} == 3 ]; then
                    COMPREPLY=(\$(compgen -W "\$(ls \${LABSFOLDER} | grep -e "^\\(\$LABPREFIX\\)" | cut -c \$(expr \${#LABPREFIX} + 1)- | sed -e ':a;N;\$!ba;s/\\n/ /g')" "\${COMP_WORDS[2]}"))
                elif [ \${#COMP_WORDS[@]} == 4 -a -d \$LABSFOLDER/Lab\${COMP_WORDS[2]}/\$USERNAME/\$LABPREFIX\${COMP_WORDS[2]} ]; then
                    COMPREPLY=(\$(compgen -W "\$(find \$LABSFOLDER/Lab\${COMP_WORDS[2]}/\$USERNAME/\$LABPREFIX\${COMP_WORDS[2]} -maxdepth 1 -mindepth 1 -type d | rev | cut -d "/" -f 1 | rev)" "\${COMP_WORDS[3]}"))
                fi
                ;;
            *)
        esac
    fi
}

complete -F _tp_completions tp
FILE_EOF

if [ ! -d ".bin" ]; then
        mkdir .bin
fi

cd .bin

cat > libportal << FILE_EOF
#!/bin/bash

# Author: Logan MacDougall
# Filename: libportal

# This will create a "portal" to your lib folder
# so that it can be accessed from anywhere

#This is done by making a symbolic link
#using the link command (ln)

LIBFOLDER="\$LIBSFOLDER"
RANDOM_MESSAGE="Now you're thinking with portals"

if [ ! -e "./libportal" ]; then
    ln -s \${LIBFOLDER} ./libportal

    if [ ! -z "\$RANDOM_MESSAGE" ]; then
        number=\$RANDOM;
        let "number %= 10";
        if [ \$number == 0 ]; then
           echo \$RANDOM_MESSAGE
        fi
    fi
fi
FILE_EOF

cat > mkscript << FILE_EOF
#!/bin/bash

# Author: Logan MacDougall
# Filename: mkscript

# Creates a file already setup with the ability
# to execute and has #!/bin/bash pre written
# at the top

if [ \$# == 0 ]; then
    echo "Must provide a file name"
    echo "Usage: mkscript NAME"
    exit 128
fi

touch \$1
chmod 755 \$1
cat >> \$1 << EOF
#!/bin/bash

EOF
FILE_EOF

cat > tp << FILE_EOF
#!/bin/bash

# Author: Logan MacDougall
# Filename: tp

# This allows users to quickly "teleport" into you lab folders
# and your lib folder. no more long cd commands just to get into
# lab folder 6, all it takes is "tp lab 6"

USERNAME=\$(whoami)

# Must set these 3 variables for it to work on your machine
LABSFOLDER="$LABSFOLDER"
LIBSFOLDER="$LIBSFOLDER"
LABPREFIX="$LABPREFIX"

if [ \$# == 0 ]; then
    echo "Usage: tp [LOCATION]";
    echo "Use \\"tp -list\\" for a list of locations"
    return 128;
else
    case \$1 in
        "-list")
            echo "You can go to the following locations:"
            echo "    lib : Goes to your lib folder."
            echo "    lab : Goes to the folder containing all the labs."
            echo "    lab [NUMBER] : Goes into the repo of lab NUMBER if it exists, otherwise, will just go into the lab NUMBER folder."
            echo "    lab [NUMBER] [CONTRACT] : Goes into the CONTRACT folder of lab NUMBER. If that contract folder doesn't exist, it will ignore CONTRACT."
            ;;

        "lib")
            cd \${LIBSFOLDER}
            ;;

        "lab")
            if [ \$# -ge 3 -a -d \$LABSFOLDER/\$LABPREFIX\$2/\$USERNAME/Lab\$2/\$3 ]; then
                cd \$LABSFOLDER/\$LABPREFIX\$2/\$USERNAME/Lab\$2/\$3
            elif [ \$# -ge 2 -a -d \$LABSFOLDER/\$LABPREFIX\$2/\$USERNAME ]; then
                cd \$LABSFOLDER/\$LABPREFIX$2/\$USERNAME
            elif [ \$# -ge 2 -a -d \$LABSFOLDER/\$LABPREFIX\$2 ]; then
                cd \$LABSFOLDER/\$LABPREFIX\$2
            else
                cd \$LABSFOLDER
            fi
            ;;

        *)
            echo "Unknow location"
            echo "Use \\"tp -list\\" for a list of locations"
            ;;
    esac
fi

return 0;
FILE_EOF

chmod 755 tp
chmod 755 libportal
chmod 755 mkscript

exit 0
