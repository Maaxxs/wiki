# Git

some random git commands.

Get git authors and the time the date of the last commit. Found
[here][1].

[1]: https://blog.bear.dev/posts/git-users-and-their-last-commits/

```
git log --pretty=format:"%an" | \
    sort | \
    uniq | \
    awk '{system("git log -1 --author="$1 " --pretty=format:\"%ad%x09%an\""); print "\r"}' | \
    sort -k5n -k2M -k3n
```

