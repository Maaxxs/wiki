# Tmux

## Write tmux buffer of a pane to a file

```sh
# get the %d pane number you want, e.g. %0
tmux list-panes
# write tmux buffer of that pane to file
tmux pipe-pane -o -t %0 "cat >> /home/user/out.log"
# stop writing to file
tmux pipe-pane -t %0 ''
```

