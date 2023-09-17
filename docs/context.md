# ConTeXt LMTX

This installs the new implementation of ConTeXt, named ConTeXt LMTX.

[Official wiki](https://wiki.contextgarden.net/Installation)


```sh
mdir $HOME/context
cd ~/context
wget https://lmtx.pragma-ade.com/install-lmtx/context-linux-64.zip
unzip context-linux-64.zip
sh install.sh
```

Add the `bin` folder of the context installatin to your path or specify
the full path to `mtxrun`

For instance, for the fish shell in `~/.config/fish/config.fish`

```sh
set -x PATH "$PATH:$HOME/context/tex/texmf-linux-64/bin"
```

You should be able to compile the detailed
[example](https://wiki.contextgarden.net/Detailed_Example).<br>
Note: Put an image next to that file called `dummy.png` as it is
referenced in the example tex file or just comment the lines.


The following is a message from the installer. Just here as a note.

> ConTeXt LMTX with LuaMetaTeX is still experimental and when you get a
> crash this can be due to a mismatch between Lua bytecode and the
> engine. In that case you can try the following:
>
>   - wipe the texmf-cache directory (e.g. `~/context/tex/texmf-cache`)
>   - run: `mtxrun --generate`
>   - run: `context --make`
>
> When that doesn't solve the problem, ask on the mailing list
> (ntg-context@ntg.nl).

## Installing Modules for LMTX

[Official instructions](https://wiki.contextgarden.net/Modules#Installation_by_script_.28LMTX.29)

To list modules:

```sh
mtxrun --script install-modules --list
```

Installation: Go to the `~/context/tex` directory (contains all the
`texmf-*` directories).

```sh
cd ~/context/tex/

# install all
mtxrun --script install-modules --install --all

# install only modules matching the filter
mtxrun --script install-modules --install filter simpleslides
```


