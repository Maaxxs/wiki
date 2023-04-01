# OpenSSL

## Show Certificate information

```sh
openssl s_client -showcerts -connect you-server.com:443 </dev/null
```

## Show SHA1 Fingerprint of Certificate

```sh
openssl s_client -connect server:port < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin
```
