# Semgrep

- can produce a graph, too
- combine search pattern and regex
- can call python code

## Rules

| Code           | Description                  |
| :--            | : --                         |
| exec(...)      | zero or more args/statements |
| exec('...')    | any string                   |
| obj.$PARAM     | match a variable name        |
| <... $VAR ...> | deep expression match        |

