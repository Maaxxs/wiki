# Bash

## Bash Conditionals

Check [6.4 Bash Conditional
Expressions](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html)
for more information.


| Option | Explanation
| --- | --- |
| -a file | True if file exists.
| -b file | True if file exists and is a block special file.
| -c file | True if file exists and is a character special file.
| -d file | True if file exists and is a directory.
| -e file | True if file exists.
| -f file | True if file exists and is a regular file.
| -g file | True if file exists and its set-group-id bit is set.
| -h file | True if file exists and is a symbolic link.
| -k file | True if file exists and its "sticky" bit is set.
| -p file | True if file exists and is a named pipe (FIFO).
| -r file | True if file exists and is readable.
| -s file | True if file exists and has a size greater than zero.
| -t fd   | True if file descriptor fd is open and refers to a terminal.
| -u file | True if file exists and its set-user-id bit is set.
| -w file | True if file exists and is writable.
| -x file | True if file exists and is executable.
| -G file | True if file exists and is owned by the effective group id.
| -L file | True if file exists and is a symbolic link.
| -N file | True if file exists and has been modified since it was last read.
| -O file | True if file exists and is owned by the effective user id.
| -S file | True if file exists and is a socket.
| file1 -ef file2 | True if file1 and file2 refer to the same device and inode numbers.
| file1 -nt file2 | True if file1 is newer (according to modification date) than file2, or if file1 exists and file2 does not.
| file1 -ot file2 | True if file1 is older than file2, or if file2 exists and file1 does not.
| -o optname | True if the shell option optname is enabled. The list of options appears in the description of the -o option to the set builtin (see The Set Builtin).
| -v varname | True if the shell variable varname is set (has been assigned a value).
| -R varname | True if the shell variable varname is set and is a name reference.
| -z string | True if the length of string is zero.
| -n string | True if the length of string is non-zero.
| string1 == string2, string1 = string2 | True if the strings are equal. When used with the [[ command, this performs pattern matching as described above (see Conditional Constructs). ‘=’ should be used with the test command for POSIX conformance.
| string1 != string2 | True if the strings are not equal.
| string1 < string2 | True if string1 sorts before string2 lexicographically.
| string1 > string2 | True if string1 sorts after string2 lexicographically.
| arg1 OP arg2 | OP is one of ‘-eq’, ‘-ne’, ‘-lt’, ‘-le’, ‘-gt’, or ‘-ge’. These arithmetic binary operators return true if arg1 is equal to, not equal to, less than, less than or equal to, greater than, or greater than or equal to arg2, respectively. Arg1 and arg2 may be positive or negative integers. When used with the [[ command, Arg1 and Arg2 are evaluated as arithmetic expressions (see Shell Arithmetic).


## Bash Prompt Escape Sequences

Check [tldp.org](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html).

| Escape Sequence | Description
| --------------- | -----------
| `\a`            | an ASCII bell character (07)
| `\d`            | the date  in  "Weekday  Month  Date"  format (e.g., "Tue May 26")
| `\e`            | an ASCII escape character (033)
| `\h`            | the hostname up to the first `.`
| `\H`            | the hostname
| `\j`            | the  number of jobs currently managed by the shell
| `\l`            | the basename of the shell's terminal  device name
| `\n`            | newline
| `\r`            | carriage return
| `\s`            | the  name  of  the shell, the basename of $0 (the portion following the final slash)
| `\t`            | the current time in 24-hour HH:MM:SS format
| `\T`            | the current time in 12-hour HH:MM:SS format
| `\@`            | the current time in 12-hour am/pm format
| `\u`            | the username of the current user
| `\v`            | the version of bash (e.g., 2.00)
| `\V`            | the release of bash,  version  +  patchlevel(e.g., 2.00.0)
| `\w`            | the current working directory
| `\W`            | the  basename  of the current working directory
| `\!`            | the history number of this command
| `\#`            | the command number of this command
| `\$`            | if the effective UID is 0, a #, otherwise a $
| `\nnn`          | the  character  corresponding  to  the octal number nnn
| `\\`            | a backslash
| `\[`            | begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt
| `\]`            | end a sequence of non-printing characters


## Bash Prompt

The normal usual colored bash prompt. Put in `.bashrc`:

```sh
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```

