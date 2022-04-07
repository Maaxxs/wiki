# LVM

## Resize a logical volume with a new physical volume

Create linux partition

```sh
gdisk /dev/nvme0n1
```

Create physical volume
```sh
pvcreate /dev/nvme0n1p1
```

Extend volume group
```sh
vgextend arch /dev/nvme0n1p1
```

Resize the logical volume `root` to use the free space in the volume group
`arch` and resize the file system at the same time.

```sh
sudo lvresize -l +100%FREE --resizefs arch/root
```
