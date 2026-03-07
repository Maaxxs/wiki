# GDB

Extensions you might want to use

* peda
* pwndbg


In `{}` brackets I wrote the shortcut of the command in the same line.
For example, instead of `print xyz` you can write `p xyz`.

- Show information about loaded file.
- Print a variable.
- Put breakpoint on the `Foo::Foo` constructor.
- Show and delete break points and watch points.

```
(gdb) info file
(gdb) print Foo:numFoos           {p}
(gdb) break Foo::Foo
# show currently set break points and watch points
(gdb) info breakpoints
# omit number to delete all break points
(gdb) delete [number]
# or in short delete all      TODO: really? or is that  info breakpoints?
(gdb) i b
```

Printing Code and Values of variables

```
# next  runs the next line of code
# what next prints here is the next command that is going to be run
# when we type  next  again.
(gdb) next              {n}
5         int k = 7;
# show code
(gdb) list              {l}
(gdb) list [line]
...
...       some code
...
# show value of variable  var
(gdb) print var
(gdb) print ((j * 3) + k * 2 ) - 2
(gdb) print *pointer

# show type of variable
(gdb) whatis var
(gdb) what var

# keeping track of the value of variable  var.
# gdb shows the value of var after every statement.
(gdb) display var
# stop displaying the value behind id 1 after every command.
(gdb) undisplay 1

# set a watchpoint: stop when a value of a variable changes
(gdb) watch var
Hardware watchpoint 2: var
```

Backtrace / Function calls

```
# show backtrace
(gdb) backtrace         {bt}

# move up and down the call stack
(gdb) up
#1  0x000555555554742 in f (i=0x77...) at example1.cc:11
(gdb) down
```


```
# step into function call, don't step over it
(gdb) step              {s}
# continue running code
(gdb) continue          {c}
# finish this current function call. -> run until we pop the current stack frame
(gdb) finish
```

Reverse Debugging

```
# record everything from this point onward
(gdb) target record-full
(gdb) next # do stuff ...
(gdb) reverse-next          {rn}
(gdb) reverse-step
(gdb) reverse-continue
```

Change the value of a variable

```
(gdb) set var x=15
```


## DSO Debugging

- `LD_BIND_NOW`: tells the linker that is should resolve all PLT calls
  when the program starts. Also compiler flags: `-Wl,-znow`
- `ldd`
- `LD_DEBUG`: use `=help` to show modes. Show you what the linkers does
- `LD_PRELOAD`: might be used to implement caching. e.g. if a function
  is called over and over again with the same arguments, then we can
  keep a histogram of values and just return the cached values without
  calling a possibly expensive function.

## Analyze a Coredump

If the coredump file is compressed, decompress it first.
This coredump is Zstandard compressed data.

```sh
zstdcat core.sway > ~/sway.coredump
```

Load the file with gdb and provide the program that caused the coredump
(optionally built with debug symbols; makes analysis much easier).

```sh
gdb -c sway.coredump sway
```

## The HEAP

- `malloc()` returns pointer to chunk of memory.
  Right before that address the size of that chunk is stored.
  Therefore, one can also add that size to the address itself and get to the next chunk.

