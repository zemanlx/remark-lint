FROM node:10.16.0-alpine

WORKDIR /lint
COPY package.json package.json .remarkrc.yaml ./
RUN npm install && npm link remark-cli

WORKDIR /lint/input
ENTRYPOINT ["/usr/local/bin/remark"]
