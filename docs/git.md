# Git

some random git commands.

Get git authors and the time the date of the last commit. Found
[here][1].

[1]: https://blog.bear.dev/posts/git-users-and-their-last-commits/

```sh
git log --pretty=format:"%an" | \
    sort | \
    uniq | \
    awk '{system("git log -1 --author="$1 " --pretty=format:\"%ad%x09%an\""); print "\r"}' | \
    sort -k5n -k2M -k3n
```

## Pull in Remote Refs

The following version was presented but I use a slightly modified
version shown below that.

```sh
git config remote.origin.fetch '+refs/pull/*:refs/remotes/origin/pull/*'
```

I use this additional fetch resource (GitHub):

```gitconfig
[remote "origin"]
    fetch = +refs/pull/*/head:refs/remotes/origin/pr/*
```

Gitlab:

```gitconfig
[remote "origin"]
    fetch = +refs/merge-requests/*/head:refs/remotes/origin/pr/*
```

Then to checkout pull request 42 I do `git checkout pr/42`.

## Set Upstream Branch for Currently Checked Out Local Branch

```sh
git branch -u upstream/foo
```


## Delete Remote Branch

```sh
git push <remote-ref> --delete <branch-name>
```

## So You Think You Know Git

Notes from the [talk by Scott Chacon][chacon-git] at FOSDEM24.

[chacon-git]: https://fosdem.org/2024/schedule/event/fosdem-2024-3611-so-you-think-you-know-git

Stash all ignored and untracked files, too.

```sh
git config --global alias.staash 'stash --all'
```

Run a script as git command.
[better git branch
script](https://gist.github.com/schacon/e9e743dee2e92db9a464619b99e94eff)

```sh
git config --global alias.bb !better-branch.sh
```

Conditional git configuration

```gitconfig
[includeIf "gitdir:~/projects/work/"]
    path = ~/projects/work/.gitconfig

[includeIf "gitdir:~/projects/oss/"]
    path = ~/projects/oss/.gitconfig
```

### Oldies

`git blame ` a little (line range)

```sh
git blame -L 15,26 path/to/file
```

Git log a specific section of a file

```sh
git log -L 15,26:path/to/file
```

Provide a function name and git will try to figure out the block you
mean heuristically

```sh
git log -L :function_name:path/to/file
```

Ignore whitespace (`-w`) and

* `-C` detect lines moved or copied in the same commit.
* `-CC` also ignore the commit that created the file.
* `-CCC` in any commit

```sh
git blame -w -CCC
```

The _pickaxe_. Filter log for anything that has `measure` in it.

```sh
git log -S measure -p
```

Log of everything you did.

```sh
git reflog
```

For small changes in text or tailwinds for example, use the
`--word-diff` option as the default (line diff) is not very helpful.

```sh
git diff
git diff --word-diff
```

### Newer Things

In a rebase or merge conflict, tell git to remember the way you resolved
this conflict and if git sees the same conflict again, it is able to fix
it automatically. REuse REcord REsolution.

```sh
git config --global rerere.enabled true
```

Put branches into columns (not one long list). Sort branches my last
date committed.

```sh
git branch --column
# or
git config --global column.ui auto
git config --global branch.sort -committerdate
```

If you want to put anything into columsn, `git` now helps you. It does
not do anything else.

```sh
seq 1 24 | git column --mode=column --padding=5
```

The _safe_ force push.

```sh
git push --force-with-lease
```

Signing commits with SSH. You can upload the public SSH key to GitHub,
GitLab, ... and it will be used to verify the signature and check the
email of a commit's author. If both are correct, this _Verified_ tag is
displayed.

```sh
git config gpg.format ssh
git config user.signingkey ~/.ssh/some_key.pub
git commit -S
```

You can also sign your `git push`. However, GitHub and GitLab do not
support this.

```sh
git push --signed
```

Run maintainance tasks in the background via a cron job so git does not
have to _tag_ it to other commands (and slowing them down).

```sh
git maintainance start
```

### Big Repositories

Not mentioned here but exists: multipack indexes, reachability bitmaps,
geometric repacking. See [this GitHub blog post][gh-mono].

[gh-mono]: https://github.blog/2021-04-29-scaling-monorepo-maintenance/

Save expensive operation to disk. The `--graph` in the git log is rather
expensive because git has to walk the whole tree before it can even
start displaying anything.

```sh
git log --graph --oneline  # slow
git commit-graph write
git log --graph --oneline  # now fast
```

The maintainance feature mentioned about will do this as well or you can
turn it on when you fetch with

```sh
git config --global fetch.writeCommitGraph true
```

File system monitor. Useful for very large repositories such as
Chromium. `fsmonitor` launches a daemon that watches for inode events.

```sh
git config core.fsmonitor true
git config core.untrackedcache true # not sure about this one
```

The following filters are useful for partial checkouts of big
repositories such as the Linux kernel, the Chromium project, or Windows.

Download all the commits and trees but only the current working tree
blobs to display in the worktree.

```sh
git clone --filter=blob:none https://github.com/torvalds/linux.git
```

Also exlude the tree. It's rarely useful but good for CI.

```sh
git clone --filter=tree:0 https://github.com/torvalds/linux.git
```

## Reset the Author for the Last Three Commits

```sh
git rebase -i --exec 'git commit --amend --reset-author --no-edit' HEAD~3
```

## Find rule from gitignore that matches

```sh
git check-ignore -v path/to/file
```

## Git Credentials Helper with pass

In the `.git/config` file your local tracked directory, you can set this specific entry that gets the password from `pass`.
Set the username to whatever the remote expects.

```conf
[credential]
  username = git
  helper = "!f() { test \"$1\" = get && echo \"password=$(pass path/to/password)\"; }; f"
```
