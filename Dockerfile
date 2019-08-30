FROM node:10.16.3-alpine

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.20

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
