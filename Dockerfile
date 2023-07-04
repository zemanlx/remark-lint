FROM node:20.3.1-alpine3.18

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.40 \
    && git config --global --add safe.directory /lint/input

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
