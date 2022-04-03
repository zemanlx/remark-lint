FROM node:16.14.2-alpine3.15

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.34

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
