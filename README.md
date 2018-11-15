# UNIX-Scripts
A collection of useful bash scripts for UNIX operating systems (Linux, macOS, BSD)

### Commandify
A tool to install shell scripts (.sh) into a directory in your $PATH to make creating and updating custom commands easy and efficient.
Self-installation (output directory will vary based on OS):
```
$ bash commandify.sh commandify.sh
SUCCESS: commandify.sh installed to /usr/local/bin/commandify
```
Arguments, all optional:
  * -f -- force, overwrite the existing command, if applicable
  * -n -- an alternate name you wish to use for the command (default is name of .sh file)
  * -p -- use specified path instead of default bin path
