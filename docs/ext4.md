# Ext4 filesystem

This comes at risk of inconsistent data when occuring a powerloss.
Tune at your own risk and know the trade-offs.

Tuning for performance:

```sh
mount -o noatime,lazytime,data=writeback,nobh,nobarrier,commit=60 /dev/nvme0n1p4 /scratch
```

Disable journal at filesystem creation.
Then mount the partition without the journaling/metadata options because they're now irrelevant.

```sh
mkfs.ext4 -O ^has_journal /dev/nvme0n1p4
mount -o noatime,lazytime,nobarrier /dev/nvme0n1p4 /localscratch
```

