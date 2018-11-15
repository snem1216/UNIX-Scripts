#!/bin/bash

# Help output
if [ "$1" = "-h" -o "$1" = "--help" -o -z "$1" ]; then cat <<EOF
Commandify for UNIX
Part of the UNIX-Scripts toolset <https://github.com/snem1216/UNIX-Scripts>
Installs bash script files to /usr/local/bin as executables so they can be used as shell commands.
Usage: commandify script.sh <optional_different_name> [ -f (overwrite existing commands) -n <different_command_name> -p <custom_path> ]
Ex. "commandify commandify.sh -p ~/mybin -n cmdfy" will install commandify.sh as cmdfy in ~/mybin
Copyright 2018 Steve Nemeti <https://github.com/snem1216>
EOF
exit; fi

# Base name of script without file extension
SCRIPT_NAME=""
SCRIPT_NAME_OVERRIDE=""
# Default location for commands, preferably one that can be modified without sudo.
# Feel free to change based on your needs
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Best location for macOS commands
    BIN="/usr/local/bin"
else
    # Best location for Linux/BSD commands
    # ~/bin is typically already built into the user's $PATH
    BIN=~/bin
fi

SOURCE_FILE_DIR=$( dirname $1)
ARGS=""
OVERWRITE=0
SUPPRESS_OVERWRITE_PROMPT=$false

while [ $# -gt 0 ]
do
    unset OPTIND
    unset OPTARG
    while getopts fn:p: flag
    do
    case $flag in
            f)  
                # Overwrites existing command without verification.
                OVERWRITE=1
                ;;
            n)
                # Use different script name from the shell script's basename
                SCRIPT_NAME_OVERRIDE=$OPTARG
                ;;
            p)
                # Output the command to a different path.
                # Removes slash at the end of the argument, if applicable.
                BIN=${OPTARG%/}
                ;;
        esac
   done
   shift $((OPTIND-1))
   ARGS="${ARGS} $1 "
   shift
done

# Remove excess spaces from ARGS (this should only be the script file)
FILENAME=$(echo "$ARGS" | awk '$1=$1')

# Determine script basename
if [ "$SCRIPT_NAME_OVERRIDE" != "" ]; then
    SCRIPT_NAME=$SCRIPT_NAME_OVERRIDE
else
    SCRIPT_NAME=$(basename "$FILENAME" ".sh")
fi


if [ -a "$BIN/$SCRIPT_NAME" ]; then
    if [ $OVERWRITE = 0 ]; then
            read -p "WARNING: $BIN/$SCRIPT_NAME already exists. Overwrite? [y/N] " y
            case $y in
                [Yy]* ) 
                    echo TIP: Turn off these prompts by using the -f flag
                    ;;
                # Assume no if answer is not Y
                * ) 
                    echo "Aborting..."
                    exit 1
                    ;;
            esac
    fi
fi

if ! [ -a $BIN ]; then
    echo Directory $BIN does not exist. Creating...
    mkdir -p $BIN
    if [ $? = 0 ]; then
        echo Successfully created directory: $BIN
    else
        echo Failed to create directory: $BIN
    fi
fi

cp "$FILENAME" "$BIN/$SCRIPT_NAME"
if [ $? = 0 ]; then 
    chmod +x "$BIN/$SCRIPT_NAME"
    if [ $? = 0 ]; then
        echo SUCCESS: $FILENAME installed to $BIN/$SCRIPT_NAME
    fi
fi