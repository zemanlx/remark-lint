FROM node:26.13.0-alpine3.24

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.54 \
    && git config --global --add safe.directory /lint/input

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
