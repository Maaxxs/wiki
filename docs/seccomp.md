Secure Computing
================

* Designed to sandbox programs that deal with untrusted input
* Installing a seccomp filter is irreversible. It's a declaration that
  subsequently executed code is not to be trusted.
* Berkeley Packet Filter (BPF)
  * small set of instructions run in a virtual machine in the kernel
  * originally designed for network packet filtering in the kernel to
    avoid passing every network packet across the kernel/userland
    boundary
  * Maximum of 4096 instructions.
  * A directed acyclic graph. No loops. Only forward branching.
  * Devs realized BPF can be used to filter syscalls too
* All filters are executed in reverse order
* child inherits filter of parent if `fork()/clone()` is permitted
* filters are also preserved across `execve()` if permitted

After all fileres ran, the value with the highest priority is returned
to the kernel.

* `SECCOMP_RET_KILL` (highest priority)
* `SECCOMP_RET_TRAP`
* `SECCOMP_RET_ERRNO`
* `SECCOMP_RET_TRACE`
* `SECCOMP_RET_ALLOW` (lowest priority)

Other resources
---------------

* [Teach seccomp][ts] how to discover which system calls don’t pass
  filtering of an application
* Seccomp sandboxes and memcached example. [part1][p1], [part2][p2]
* BPT compiler (bpfc) part of <http://netsniff-ng.org/>

[ts]: http://outflux.net/teach-seccomp/
[p1]: blog.viraptor.info/post/seccomp-sandboxes-and-memcached-example-part-1
[p2]: blog.viraptor.info/post/seccomp-sandboxes-and-memcached-example-part-2
