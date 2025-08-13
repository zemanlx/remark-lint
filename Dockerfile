FROM node:24.5.0-alpine3.22

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.49 \
    && git config --global --add safe.directory /lint/input

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
