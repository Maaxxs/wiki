Build a static binary
=====================

Using

```sh
RUSTFLAGS='-C target-feature=+crt-static' cargo build --release
```

returns this head scratching error:

```
error: cannot produce proc-macro for `async-trait v0.1.74` as the target `x86_64-unknown-linux-gnu` does not support these crate types
```

Fix it by specifying the target platform.

```sh
RUSTFLAGS='-C target-feature=+crt-static' cargo build --release --target x86_64-unknown-linux-gnu
```

If the output is still a dynamic binary, it's probably because some
dependency `*-sys` *requires* dynamic linking such as `hyper` (links with
cURL) or `rustls` (links with openssl) according to
[this](https://msfjarvis.dev/posts/building-static-rust-binaries-for-linux/).

