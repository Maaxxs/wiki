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
