# Advanced Search

## Google Search Syntax

Use: `operator:search_term`

Operators
```
intitle, allintitle, inurl, allinurl, filetype, allintext, site, inanchor, numrange, daterange
```

The operator `link` was removed in 2017 (used to find all websites referencing `link:<some-link>`).

Special characters:
```
“ .. * | ()-
```

Search for php query tools
```
filetype:php inurl:nqt intext:"Network Query Tool“
```

Search for port 1080
```
inurl:1080
```

## Search Tools
- [Google Hacking Database (GHDB)](https://www.exploit-db.com/google-hacking-database/)
- [Censys](https://censys.io) ([Whitepaper](https://www.censys.io/static/censys.pdf))
- TODO: Check this <https://resources.bishopfox.com/resources/tools/google-hacking-diggity/attack-tools/>
- [Foca (Fingerprinting Organizations with Collected Archives)](https://github.com/ElevenPaths/FOCA) (windows only) 


## Whois Databases
- [RIPE NCC: Europe, Central Asia and the Middle East](https://www.ripe.net/)
- [APNIC: Asia Pacific](https://www.apnic.net/)
- [AFRINIC: Africa](http://www.afrinic.net/)
- [ARIN: North America](http://whois.arin.net/)
- [Lacnic: Latin America and the Caribbean](http://lacnic.net/)

## DNS
- `dig`
```
dig ns zonetransfer.me
dig axfr @nameserver zonetransfer.me
```
- `fierce`: e.g. <https://github.com/mschwager/fierce>
```
fierce -dns zonetransfer.me
```

## Certificates

- <https://crt.sh> Certificate Transparency Logs
- <https://censys.io> 
- <https://findsubdomains.com/>
- <http://dnstrails.com/>


