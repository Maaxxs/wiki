# Storage

CPU has 16 Cores (Threads).
```sh
$ lscpu | grep 'CPU(s)'
CPU(s):                                  16
```

Scheduler creates 16 queues, one for each core.
```sh
$ ls /sys/block/nvme0n1/mq/
0/  1/  10/  11/  12/  13/  14/  15/  2/  3/  4/  5/  6/  7/  8/  9/
```

My nvme SSD supports even more queues, 64 queues.

```sh
$ sudo nvme get-feature /dev/nvme0n1 -f 7 -H
get-feature:0x07 (Number of Queues), Current value:0x003f003f
        Number of IO Completion Queues Allocated (NCQA): 64
        Number of IO Submission Queues Allocated (NSQA): 64
```

Show support schedulers.
The active one is surround by square brackets.

```sh
$ cat /sys/block/nvme0n1/queue/scheduler
[none] mq-deadline kyber bfq
```
