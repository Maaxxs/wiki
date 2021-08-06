---
title: "Pi-hole"
date: 
tags: ["wiki"]
ShowLastUpdated: false
toc: true
draft: false
---

# Pi-hole

## Removing an entry from audit list

Go to `/etc/pihole/` and do `sudo sqlite3 gravity.db`

```sql
select * from domain_audit;
```

```sql
delete from domain_audit where id=1;
```

