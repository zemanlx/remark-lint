FROM node:12.16.1-alpine3.11

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.24

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
