# Docker image for remark-lint

Docker image for remark-lint markdown code style linter

## Build

```bash

docker build -t zemanlx/remark-lint .
```

## Use

Go to your folder with markdown files you want to lint and run

```bash
docker run --rm -i -v $PWD:/repository:ro zemanlx/remark-lint
```
