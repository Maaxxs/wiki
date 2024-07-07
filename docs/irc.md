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

## Reclaim your Nick

You nick might be used by somebody else if you weren't connected to the
IRC server. Or your ISP assigned you a new IP and when you IRC bouncer
logged in again, it couldn't use that nick because the IRC server still
thinks that this nick is in use.

Execute the following two commands after authenticating yourself to the
IRC server. Sometimes only the second one is necessary and supported
(e.g. OFTC).

```
/msg NickServ RELEASE yournick
/msg NickServ REGAIN yournick
```

