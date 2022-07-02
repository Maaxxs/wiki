# Pandoc

## Installation

I installed it via `brew`.
```sh
brew install pandoc
```

Make sure you have MacTeX installed, too.
```sh
brew install mactex
```


## Templates

Generate pdfs, which look a bit better than the default. I used the
[Eisvolgel](https://github.com/Wandmalfarbe/pandoc-latex-template) template.

Download the `eisvogel.latex` and move it to the templates directory.

```sh
mkdir -p .local/share/pandoc/templates/
mv eisvogel.latex .local/share/pandoc/templates/
```

Generate the pdf:
```sh
pandoc file.md -o file.pdf --template eisvogel --listings
```

