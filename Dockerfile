FROM node:22.5.1-alpine3.20

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.45 \
    && git config --global --add safe.directory /lint/input

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
