# Commands

Recursively look for links formatted in markdown syntax and print all of
them to stdout without mentioning the file name or line number.

```sh
rg -NIoi '\[.*?\]\((http.*?)\)' -r '$1' --no-heading
```

For instance, this can be used to open all links in a project in a browser

```sh
rg -NIoi '\[.*?\]\((http.*?)\)' -r '$1' --no-heading | xargs firefox
```

