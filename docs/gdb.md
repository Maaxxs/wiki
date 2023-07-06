# GDB

Extension: peda

show information about file
```
info file
```

## The HEAP

- `malloc()` returns pointer to chunk of memory. right before that address the
  size of that chunk is stored. Therefore, one can also add that size to the
  address itself and get to the next chunk.

## Analyze a Coredump

If the coredump file is compressed, decompress it first. This coredump is
Zstandard compressed data.

```sh
zstdcat core.sway > ~/sway.coredump
```

Load the file with gdb and provide the program that caused the coredump
(optionally built with debug symbols; makes analysis much easier).

```sh
gdb -c sway.coredump sway
```

##

Print variable and put breakpoint on the `Foo::Foo` constructor.

```
(gdb) p Foo:numFoos
(gdb) break Foo::Foo
```


## DSO debugging

- `LD_BIND_NOW`: tells the linker that is should resolve all plt calls
  when the program starts. also compiler flags: `-Wl,-znow`
- `ldd`
- `LD_DEBUG`: use `=help` to show modes. Show you what the linkers does
- `LD_PRELOAD`: might be used to implement caching. e.g. if a function
  is called over and over again with the same arguments, then we can
  keep a histogram of values and just return the cached values without
  calling an perhaps expensive function.
