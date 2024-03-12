OpenSMTPD
=========

Increase log verbosity

```sh
$ smtpctl log verbose
$ for i in smtp mta expand lookup rules; do \
  doas smtpctl trace $i;\
done
```

Creating a trap
---------------

found on misc@openbsd mailing list

doing more or less greytrapping with rspamd.
Usually one would use `spamd(8)` for that, see [this][peter] by Peter
Hansteen.

[peter]: https://nxdomain.no/~peter/in_the_name_of_sane_email.html

```
Here is howto:
At first, collect spoiled email addresses to some list, for example
/etc/mail/traps.
Second, we must map these addresses to some local user, because
otherwize, smtpd will not know where to put them.
To do this, we must make another table, with mapping all addresses to
_rspamd user.
You can do this with a simple sed pattern:
cat /etc/mail/traps | sed 's/$/ _rspamd/' > /etc/mail/virtualtraps
Now we have two tables, traps for matching and virtualtraps for action.

add something like this to smtpd.conf:
----
table traps file:/etc/mail/traps
table virtualtraps file:/etc/mail/virtualtraps

action "trap" mda "/usr/local/bin/rspamc -f 1 -w 10 fuzzy_add" virtual
<virtualtraps>

match from any for rcpt-to <honeypot> action "trap"
----

The match directive should be placed above the main domain match.
And voila!
You can monitor teaching with grep:
grep -F -f /etc/mail/traps /var/log/maillog
```


Block Some Senders
------------------

```
table blocked_senders file:/etc/smtpd/blocked_senders
match from any for any mail-from <blocked_senders> reject
```

Or in the via a filter (pseudo config):

```
table bad_guys file:/etc/mail/bad_guys
filter "bad_guys" phase mail-from match mail-from regex <bad_guys> reject
"550 Bad Guys"
listen on ... filter { ..., "bad_guys", ... } tag PORT_25
```
