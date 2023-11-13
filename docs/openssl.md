# OpenSSL

## Show Certificate information

```sh
openssl s_client -showcerts -connect you-server.com:443 </dev/null
```

## Show SHA1 Fingerprint of Certificate

```sh
openssl s_client -connect server:port < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin
```

## Send a Certificate Status Request to the Server

If the server supports OCSP stapling, openssl will show the result in
the response printed on stdout. Use the `-status` flag

```sh
openssl s_client -connect example.com:443 -status
```
