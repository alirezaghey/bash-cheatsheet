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
|Shortcut | Description |
|---------|--------------|
|`h` | displays help|
|`q` | quits|
|`f\|F` | add/remove/sort fields|
|`<\|>` | move sort field|
|`k` | kill process|
|`d\|s` | set update interval|
| `P, M` | sort by CPU/memory usage|
| `R` | reverse sort|
| `L` | search for string|
| `o` | add filter|
| `=` | clear filters|

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

### `mount`

**Mounts a filesystem or lists mounted filesystems**.

```bash
# show all mounted filesystems
mount

# show mounted filesystems of a specific filesystem type
mount -t {{iso9660|ext4|vfat|fuseblk}}

# mount a device to a directory
mount -t {{filesystem_type}} {{path/to/device_file}} {{path/to/target_directory}}
```

### `umount`

**Unmounts a filesystem.**

```bash
# unmount a filesystem
umount {{path/to/target_directory|path/to/device_file}}
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

## Resources

1- [Nice website](https://explainshell.com/) explaining bash commands.
