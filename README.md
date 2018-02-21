# Docker image for remark-lint

Docker image for remark-lint markdown code style linter

## Build

```bash

docker build -t zemanlx/remark-lint .
```

## Use

Go to your folder with markdown files you want to lint and run

```bash
docker run --rm -i -v $PWD:/lint/input:ro zemanlx/remark-lint .
```

In case you want to customize rules like `max-line-lenght` you can find
examples of configuration in JSON and YAML in `examples` folder. All you need
to do is copy it to your project root and customize.
