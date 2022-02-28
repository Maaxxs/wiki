# Docker

## Dockerignore

See
[StackOverflow](https://stackoverflow.com/questions/28097064/dockerignore-ignore-everything-except-a-file-and-the-dockerfile)
and the [Official
Documentation](https://docs.docker.com/engine/reference/builder/#dockerignore-file).

```dockerignore
# Ignore everything
**

# Allow files and directories
!/file.txt
!/src/**

# Ignore unnecessary files inside allowed directories
# This should go after the allowed directories
**/*~
**/*.log
**/.DS_Store
**/Thumbs.db
```
