# Tshark

```sh
tshark -i wlan0 -T fields -d tcp.port==80,http -e http.request.method -e http.request.full_uri -e http.user_agent -e http.cookie -e http.referer -e http.location -E separator=, -E quote=d
```





