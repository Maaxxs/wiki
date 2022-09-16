# IRC

## Irssi

remove clutter in irssi

```
/window hidelevel +joins +parts +quits
```

get it back:
```
/window hidelevel -joins -parts -quits
```

To hide it for all networks, delete the network line, otherwise specify a
network.

```
ignores = ( {
   level = "JOINS PARTS QUITS";
   #network = "your chatnet name";
} );
```

### adding a network

```
/network add network-name
/server add -tls -network network-name irc.server.org 6697
/connect network-name
```

search channel with wildcard with minimum of 10 and max of 30 number of people

```
/list *arch*,>10,<30
```


