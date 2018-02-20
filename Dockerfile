FROM node:8.9.4-alpine

RUN npm install --global \
  remark-cli@5.0.0 \
  remark-lint@6.0.1 \
  remark-preset-lint-consistent@2.0.1 \
  remark-preset-lint-markdown-style-guide@2.1.1 \
  remark-preset-lint-recommended@3.0.1 \
  remark-validate-links@7.0.0

COPY .remarkrc ${HOME}/

WORKDIR /repository

CMD ["remark", "--frail", "."]
