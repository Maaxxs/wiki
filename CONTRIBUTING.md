# Contributing

## Style

- File name has to be lowercase
- Convert Tabs to Spaces: YES
- Tab Size: 2
- Markdownlint should not complain, except for MD040
- Recommended Extensions for VS Code
  - Markdownlint by David Anson
  - Markdown All in One by Yu Zhang

VS Code settings could look like

```
{
    // Usual Tab size is 4, but in Markdown 2
    "editor.tabSize": 4,
    "[markdown]": {
        "editor.quickSuggestions": false,
        "editor.tabSize": 2
    },
    // ignore MD040
    "markdownlint.config": {
        "MD013": false,
        "MD040": false,
    },
}
```