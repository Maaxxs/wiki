# Latex

## Format document

On Archlinux, to make `latexindent` work, install the optional dependencies of the package `texlive-binextra`:

```sh
pacman -S perl-yaml-tiny perl-file-homedir
```

## Suggest Changes Macro

Macro to work with others on a document and suggest changes that are
rendered nicely in the PDF.

```latex
\newcommand{\suggest}[2]{
        \textcolor{red}{\sout{#1}}
        \textcolor{olive}{#2}
}
```
