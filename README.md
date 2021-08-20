# Bash Cheatsheet

## HereDoc

```bash
[COMMAND] <<[-] 'DELIMITER'
  HERE-DOCUMENT
DELIMITER
```

- The first line starts with an optional command followed by the special redirection operator `<<` and the delimiting identifier.
  - You can use any string as a delimiting identifier, the most commonly used are `EOF` or `END`.
  - If the delimiting identifier is unquoted, the shell will substitute all variables, commands and special characters before passing the here-document lines to the command.
  - Appending a minus sign to the redirection operator `<<-`, will cause all leading tab characters to be ignored. This allows you to use indentation when writing here-documents in shell scripts. Leading whitespace characters are not allowed, only tab.
- The here-document block can contain strings, variables, commands and any other type of input.
- The last line ends with the delimiting identifier. White space in front of the delimiter is not allowed.

```bash
cat << EOF
The current working directory is: $PWD
You are logged in as: $(whoami)
EOF
# Output
# The current working directory is: /path/to/current/directory
# You are logged in as: your_username
```

Instead of displaying the command's output (`cat` in this case) on the screen you can redirect it using the `>`, `>>`, or `|` operators.

```bash
# write ouput of previous command to file.txt
cat << EOF > file.txt
The current working directory is: $PWD
You are logged in as: $(whoami)
EOF
```

```bash
# write heredoc output to sed input
cat <<'EOF' |  sed 's/l/e/g'
Hello
World
EOF
# Output
# Heeeo
# Wored
```

## Process & memory management

### `top`

Dispaly dynamic real-time information about running processes.

| Shortcut | Description              |
| -------- | ------------------------ |
| `h`      | displays help            |
| `q`      | quits                    |
| `f\|F`   | add/remove/sort fields   |
| `<\|>`   | move sort field          |
| `k`      | kill process             |
| `d\|s`   | set update interval      |
| `P, M`   | sort by CPU/memory usage |
| `R`      | reverse sort             |
| `L`      | search for string        |
| `o`      | add filter               |
| `=`      | clear filters            |

### `ps`

Information about running processes.

```bash
# List processes that belong to the current user and are running in the current terminal.
ps

# List all running processes.
ps aux

# List all running process including the full command string:
ps auxww

# List all processes that belong to a specific user in full format.
ps --user $(id -u {{username}}) -f
```

### Linux Process Signals

| Signal | Name   | Description                                     |
| ------ | ------ | ----------------------------------------------- |
| 1      | `HUP`  | Hang up                                         |
| 2      | `INT`  | Interrupt                                       |
| 3      | `QUIT` | Stop running                                    |
| 9      | `KILL` | Unconditionally terminate                       |
| 11     | `SEGV` | Segment violation                               |
| 15     | `TERM` | Terminate if possible                           |
| 17     | `STOP` | Stop unconditionally but don't terminate        |
| 18     | `TSTP` | Stop or pause but continue to run in background |
| 19     | `CONT` | Resume execution after `STOP` or `TSTP`         |

## Filesystem commands

### Finding information about block devices

```bash
lsblk
# SATA and SCSI devices start `sd`
# SSD devices start `nvme`
# IDE devices start `hd`
# you can also list the files under /dev/ to see all devices
```

### Creating partitions

```bash
# Creates a new partition; Can't extend a partition
fdisk
gdisk
# Creates a new partition; Can extend a partition
parted
```

### Creating a filesystem

````bash
mkfs.ext2, mkfs.ext3, mkfs.ext4        # create an ext2/3/4 filesystem
mkfs.fat                               # create a FAT filesystem
mkfs.ntfs                              # create a NTFS filesystem
### `mount`

**Mounts a filesystem or lists mounted filesystems**.

```bash
# show all mounted filesystems
mount

# show mounted filesystems of a specific filesystem type
mount -t {{iso9660|ext4|vfat|fuseblk}}

# mount a device to a directory
mount -t {{filesystem_type}} {{path/to/device_file}} {{path/to/target_directory}}
````

### `umount`

**Unmounts a filesystem.**

```bash
# unmount a filesystem
umount {{path/to/target_directory|path/to/device_file}}
```

### Check and repair filesystems

```bash
# Does not work on NTFS
fsck
```

### `df`

**Gives an overview of the disk space usage.**

```bash
# Display all filesystems and their disk usage:
df

# Display all filesystems of type ext4 and fat32 and their disk usage:
df -t ext4 -t fat32
```

### `du`

**Estimate and summerize file and directory space usage.**

```bash
# List the sizes of a directory and its subdirectories, possibly in (B/KB/MB)
du [-{{b|k|m}}] {{path/to/directory}}

# Show the size of a singly directory, in human readable units:
du -sh {{path/to/directory}}

# List the human-readable size of all .jpg files in subdirectories of the current directory, and show a total at the end:
du -ch */*.jpg
```

## Snap

```bash
# List all snap packages
snap list

# Find a snap package
snap find {{package_name}}

# Install a snap package
snap install {{package_name}}

# Update a package
snap refresh {{package_name}}

# Update all packages
snap refresh

# Uninstall a package
snap remove {{package_name}}
```

## Command Substitution

Command Sustitution allows you to put the output of a command directly into a variable.

There are two methods of command substitution:

```bash
# The first method is to use the `$(here_goes_the_command)` syntax.
var=$(ls -l)

# The second method uses backticks `here_goes_the_command`.
var=`ls -l | sed 's/ /_/g'`
```

## Input/Output Redirection

```bash
# Redirect standard output to a file
echo "Hello World" > file.txt   # creates a file or overwrites an existing file
echo "Hello World" >> file.txt # creates a file or appends to an existing file

# Redirect file output to command standard input
wc < file.txt           # reads file and feeds it to wc

# Redirect standard error to a file
ls -l /etc/passwd 2> error.txt

# Redirect standard output and standard error to a file
# This is equivalent to 1> log.txt 2>&1
# Note that 2>&1 1> log.txt is not correct because when stderr is redirected to stdout, still doesn't point to log.txt
ls -l /etc/passwd &> log.txt

# hide error and/or stdandar output
ls -l /etc/passwd > /dev/null

# Create additional file descriptors
exec 3> file.txt
echo "Hello World" >&3

# Redirecting file descriptors and restore them
exec 3>&1 # keep a copy of stdout
exec 1> file.txt # redirect stdout to file

echo "Hello World" # writes to file.txt
echo "More Hello World" # writes to file.txt

exec 1>&3 # restore stdout to original

echo "Hello World" # writes to terminal

```

## Pipelines

Internally, bash opens a sub-shell for each command in a pipeline.
Keep in mind that sub-shells have access to a copy of all the parent's shell variables and functions (exported or not). Any changes the sub-shell makes is lost to the parent shell.

```bash
# pipe output of ls to input of sort
ls -a | sort

# pipe standard and error output of ls to input of sort
# this is equivalent to 2>&1 |
ls -a |& sort
```

## Arithmetic Expansion

```bash
# anything inside $(()) is arithmetically evaluated and the result is substiuted
echo $((3+4))

# combination of command sub-shell and arithmetic expansion
echo $(($(echo 3+4)*2))

# $[] is the old format arithmetic expansion and will be removed in the future
echo $[3+4]
```

## Conditionals

**Note:** `[[` is actually a command/programm that has an exit code of 0 or one based on the evaluation of the expression. Any program that obeys the same logic, like base utils such as `grep` or `ping`, can be used in its stead.

### string comparisons

| Condition                        | Description                    |
| -------------------------------- | ------------------------------ |
| `[[ -z "$string" ]]`             | empty string                   |
| `[[ -n "$string" ]]`             | non-empty string               |
| `[[ "$string1" == "$string2" ]]` | string equality                |
| `[[ "$string1" != "$string2" ]]` | string inequality              |
| `[[ "$string" =~ regex ]]`       | regex string match             |
| `[[ "$string1" < "$string2" ]]`  | string comparison less than    |
| `[[ "$string1" > "$string2" ]]`  | string comparison greater than |

### integer comparisons

| Condition                   | Description                      |
| --------------------------- | -------------------------------- |
| `[[ "$int1" -eq "$int2" ]]` | integer equality                 |
| `[[ "$int1" -ne "$int2" ]]` | integer inequality               |
| `[[ "$int1" -lt "$int2" ]]` | integer less than                |
| `[[ "$int1" -gt "$int2" ]]` | integer greater than             |
| `[[ "$int1" -le "$int2" ]]` | integer less than or equal to    |
| `[[ "$int1" -ge "$int2" ]]` | integer greater than or equal to |

The `(( ))` construct also allows a range of integer and bitwise operations as discussed in "Arithmetic Expansion" in addition to integer comparisons.

| Condition                  | Description                      |
| -------------------------- | -------------------------------- |
| `(( "$int1" == "$int2" ))` | integer equality                 |
| `(( "$int1" != "$int2" ))` | integer inequality               |
| `(( "$int1" < "$int2" ))`  | integer less than                |
| `(( "$int1" > "$int2" ))`  | integer greater than             |
| `(( "$int1" <= "$int2" ))` | integer less than or equal to    |
| `(( "$int1" >= "$int2" ))` | integer greater than or equal to |
| `(( int++ ))`              | post-increment                   |
| `(( int-- ))`              | post-decrement                   |
| `(( ++int ))`              | pre-increment                    |
| `(( --int ))`              | pre-decrement                    |
| `(( int1*int2 ))`          | integer multiplication           |
| `(( int1/int2 ))`          | integer division                 |
| `(( int1%int2 ))`          | integer modulus                  |
| `(( int1**int2 ))`         | integer exponentiation           |
| `(( int1&int2 ))`          | bitwise AND                      |
| `(( int1 \| int2 ))`       | bitwise OR                       |
| `(( int1^int2 ))`          | bitwise XOR                      |
| `(( int1<<int2 ))`         | bitwise left shift               |
| `(( int1>>int2 ))`         | bitwise right shift              |

**Note:** `((` syntax introduces indirection.

### File comparisons

| Condition                    | Description                 |
| ---------------------------- | --------------------------- |
| `[[ -e "$file" ]]`           | file exists                 |
| `[[ -d "$file" ]]`           | file is a directory         |
| `[[ -f "$file" ]]`           | file is a regular file      |
| `[[ -h "$file" ]]`           | file is a symbolic link     |
| `[[ -p "$file" ]]`           | file is a named pipe (FIFO) |
| `[[ -r "$file" ]]`           | file is readable            |
| `[[ -w "$file" ]]`           | file is writable            |
| `[[ -s "$file" ]]`           | file size > 0 bytes         |
| `[[ -x "$file" ]]`           | file is executable          |
| `[[ "$file1" -nt "$file2"]]` | file1 is more recent        |
| `[[ "$file1" -ot "$file2"]]` | file1 is less recent        |
| `[[ "$file1" -ef "$file2"]]` | file1 is the same as file2  |

### Logical operators

| Operator                 | Description |
| ------------------------ | ----------- |
| `[[ expr1 && expr2 ]]`   | logical And |
| `[[ expr1 \|\| expr2 ]]` | logical Or  |
| `[[ ! expr ]]`           | logical Not |

### Misc

| Comparison          | Description   |
| ------------------- | ------------- |
| `[[-o "$optnmae"]]` | option is set |

### Examples

```bash
# string
if [[ -z "$string" ]]; then
  echo "String is empty"
elif [[ -n "$string" ]]; then
  echo "String is not empty"
else
  echo "This never happens"
fi

# integer
if [[ "$int1" -eq "$int2" ]]; then
  echo "int1 is equal to int2"
elif [[ "$int1" -gt "$int2" ]]; then
  echo "int1 is greater than int2"
else
  echo "int1 is less than int2"
fi

# file
if [[ -e "$file" ]]; then
  echo "file exists"
fi
```

_Keep in mind that there must be a space between the brackets and the condition_

## Loops

```bash
# basic for loop
for file in /path/to/files/*; do
  echo "$file"
done

# C-like for loop
for (( i=0; i<10; i++ )); do
  echo "i is $i"
done

# ranges
for i in {1..10}; do
  echo "i is $i"
done

for i in {1..10..2}; do
  echo "i is $i"
done

# reading from stdin
IFSOLD=$IFS
IFS=$'\n'
cat file.txt | while read line; do
  echo "$line"
done
IFS=$IFSOLD
```

### redirecting the output of loops

```bash
for line in "$file.txt"; do
  echo "$line"
done> output.txt
```

## Variables

### Arrays

```bash
# Creating an array
nums=("zero" "one" "two" "three")
# alternatively
nums[0]="zero"
nums[1]="one"
nums[2]="two"
nums[3]="three"

# Accessing an array
echo "${nums[0]}"           # Element #0
echo "${nums[-1]}"          # Last element
echo "${nums[@]}"           # All elements, space-separated
echo "${#nums[@]}"          # Number of elements
echo "${#nums}"             # String length of the 1st element
echo "${#nums[3]}"          # String length of the Nth element
echo "${nums[@]:3:2}"       # Range (from position 3, length 2)
echo "${!nums[@]}"          # Keys of all elements, space-separated

# Modifying an array
nums=("${nums[@]}" "five")          # Push
nums+=('five')                      # Also Push
nums=( ${nums[@]/Ap*/} )            # Remove by regex match
unset nums[2]                       # Remove one item
nums=("${nums[@]}")                 # Duplicate
nums=("${nums[@]}" "${Veggies[@]}") # Concatenate
lines=(`cat "logfile"`)             # Read from file

# Iterating over arrays
for var in "${nums[@]}"; do
  echo "$var"
done

```

## read input

```bash
# using echo and read
echo -n "Enter your name: "
read name

# using read prompt
read -p "Enter your name: " name

# getting first and last name on the same line
read -p "Enter your first and last name: " firstname, lastname
```

The following are simple applications of `getopt`, `getopts`, and a combination of interactive and command-line input.

- [`getopt` example](./read_input/extractwithgetopt.sh)
- [`getopts` example](./read_input/extractwithgetopts.sh)
- [`getopts` with parameters example](./read_input/extractoptsparamswithgetopts.sh)
- [`getopts` combined with interactive example](./read_input/CheckSystems.sh)

## User management

### `useradd`

```bash
# create a new user
useradd -m {{username}}

# print or change default useradd configuration
useradd -D
```

## Useful special parameters

| Parameter | Description                                 |
| --------- | ------------------------------------------- |
| `$?`      | exit code of the last command               |
| `$*`      | all positional parameters as a single word  |
| `$@`      | all positional parameters as separate words |
| `$#`      | number of positional parameters             |
| `$$`      | expands to the process ID                   |
| `$!`      | PID of the last background process          |
| `$$`      | expands to the process ID of the shell      |
| `$0`      | filename of the current shell               |

## Misc

```bash
# Open last executed command in the default editor
fc

# List all built-in commands
compgen -A builtin
```

## Resources

1- [Nice website](https://explainshell.com/) explaining bash commands.
2- [Bash a-z](https://mywiki.wooledge.org/)
