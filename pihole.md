# PiHole

## Removing an entry from audit list

Go to `/etc/pihole/` and do `sudo sqlite3 gravity.db`

```sql
select * from domain_audit;
```

```sql
delete from domain_audit where id=1;
```

