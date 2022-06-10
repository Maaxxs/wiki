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
