# SpinRite

[Homepage of SpinRite](https://www.grc.com/sroverview.htm)

## Level of Operation

| Level   | Description
| ------- | -----------
| 1       | readonly
| 2       | allowed to do data recover. only rewrite regions in need of repair
| 3       | always rewrites the drive's data
| 4       | writing inverted data, reading it back to verify and then writing back the original data, again reading it back to verify that it was written correctly


Not all levels should be used on all sorts of drives. Only use the first and
second one with

- SSDs
- SMR drives
- drives with an SSD as front end

