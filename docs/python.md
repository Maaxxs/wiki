# Python

Show path of site-packages.
Nice to show whether the python executalbe of a venv is loaded:

```sh
$ python3 -c 'import site; print(site.getsitepackages())'
['/usr/lib/python3.13/site-packages']
```

or in venv:

```sh
$ ./venv/bin/python3 -c 'import site; print(site.getsitepackages())'
['/home/user/path/to/project/venv/lib/python3.10/site-packages', '/home/user/path/to/project/venv/local/lib/python3.10/dist-packages', '/home/user/path/to/project/venv/lib/python3/dist-packages', '/home/user/path/to/project/venv/lib/python3.10/dist-packages']
```
