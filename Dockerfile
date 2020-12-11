FROM node:14.15.1-alpine3.12

WORKDIR /lint
COPY package.json package-lock.json .remarkrc.yaml ./
RUN npm install \
    && npm link remark-cli \
    && apk add --no-cache git~=2.26

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
