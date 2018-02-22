[![Build Status](https://travis-ci.org/zemanlx/remark-lint.svg?branch=master)](https://travis-ci.org/zemanlx/remark-lint) [![Docker Automated build](https://img.shields.io/docker/automated/zemanlx/remark-lint.svg)](https://hub.docker.com/r/zemanlx/remark-lint/) [![Docker Build Status](https://img.shields.io/docker/build/zemanlx/remark-lint.svg)](https://hub.docker.com/r/zemanlx/remark-lint/)
# Docker image for remark-lint

Docker image for markdown code style linter [remark-lint](https://github.com/remarkjs/remark-lint).

## Get

Pull image from [Docker Hub](https://hub.docker.com/r/zemanlx/remark-lint/)

```bash
docker pull zemanlx/remark-lint
```

## Build

Clone this repository and run

```bash
docker build -t zemanlx/remark-lint .
```

## Use

Go to your folder with markdown files you want to lint and run

```bash
docker run --rm -i -v $PWD:/lint/input:ro zemanlx/remark-lint .
```

You can even set it up as an alias for remark-cli's command `remark`.

```bash
alias remark="docker run --rm -i -v $PWD:/lint/input:ro zemanlx/remark-lint"

remark --version
remark: 9.0.0, remark-cli: 5.0.0
```

Default config is `.remarkrc.yaml`

```yaml
plugins:
  preset-lint-consistent:
  preset-lint-markdown-style-guide:
  preset-lint-recommended:
  validate-links:
```

### Example

```bash
docker run --rm -i -v $PWD:/lint/input:ro zemanlx/remark-lint .

README.md
  3:100  warning  Line must be at most 80 characters  maximum-line-length         remark-lint
    8:1  warning  Remove 1 line before node           no-consecutive-blank-lines  remark-lint

⚠ 2 warnings
```

### Rule Customisation

In case you want to customize rules like `maximum-line-length` you can find
examples of configuration in JSON and YAML in the `examples` folder. All you
need to do is copy it to your project root and customize.

See list of all rules in [remark-lint/packages](https://github.com/remarkjs/remark-lint/tree/master/packages).

### Continuous Integration

An option `-f` or `--frail` can be useful for exiting with code `1` in case of
any warning in your CI.

```bash
docker run --rm -i -v $PWD:/lint/input:ro zemanlx/remark-lint --frail .
```

#### Travis CI

Your minimal configuration can look like

```yaml
# Docker is required to run the linter
sudo: required
services:
  - docker
# Use your language or generic image to cut start-up time
language: generic
install:
  - docker pull zemanlx/remark-lint
script:
  - docker run --rm -i -v $PWD:/lint/input:ro zemanlx/remark-lint --frail .
```

You can extend this example with your build instructions and tests or add it
as a job to one of your stages.
