FROM node:14.16.0-alpine3.13

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.30

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
