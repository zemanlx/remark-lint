#!/bin/bash

#
# Update node Docker image and npm dependencies and run tests
#

set -o errexit  # Exit immediately if any command or pipeline of commands fails
set -o errtrace # Inherit ERR trap in functions, subshells and substitutions
set -o nounset  # Treat unset variables and parameters as an error
set -o pipefail # Exit when command before pipe fails
set -o xtrace   # Debug mode expand everything and print it before execution

cd "$(dirname "$0")" # Always run from script location

test_image() {
    docker build -t zemanlx/remark-lint .
    docker run --rm -i -v "${PWD}:/lint/input:z" zemanlx/remark-lint --frail .
}

branch="update/$(date --utc '+%Y-%m-%d')"

# Make sure we branch from the latest main branch
git reset --quiet --hard HEAD
git checkout --quiet main
git pull --quiet

# Delete that local branch if it already exist and create it again to start
# from scratch
if git show-ref --quiet --verify "refs/heads/${branch}"; then
    git branch --quiet --delete --force "${branch}"
fi
git checkout --quiet -b "${branch}"

#
# Update docker image
#

# Get latest tag of node LTS (10, 12, 14, etc.) version of node Docker image
# based on alpine
image_tag=$(curl 'https://hub.docker.com/v2/repositories/library/node/tags/?page_size=50&page=1&name=alpine' \
    | jq -r '.results[].name' \
    | grep -E "^($(seq --separator "|" 10 2 200))\.[0-9]+\.[0-9]-alpine[0-9]+\.[0-9]+$" \
    | sort -t "." -k1n -k2n -k3n -k4n \
    | tail -n 1)

# Get major and minor version of git package for image_tag
git_version=$(docker run -i --rm "node:${image_tag}" apk --no-cache --quiet list 'git' | sed -r 's/^git-([0-9]+\.[0-9]+).*/\1/')

sed -i -r "s/^(FROM node:).+$/\1${image_tag}/" Dockerfile
sed -i -r "s/(git~=)[0-9]+.[0-9]+/\1${git_version}/" Dockerfile

# If there were any changes to the Dockerfile, test it and commit them
if ! git diff --quiet Dockerfile; then
    test_image
    git add Dockerfile
    git commit --message "Update Docker image: ${image_tag} and git: ${git_version}"
fi

#
# Update npm dependencies
#

# Install current dependencies to do not duplicated packages in 'npm outdated'
docker run --rm -i --volume "${PWD}:${PWD}" --workdir "${PWD}" "node:${image_tag}" \
    ash -c 'npm install && chown '"$(id -u):$(id -g)"' -R .'

# Update package.json to latest dependencies
docker run --rm -i --volume "${PWD}:${PWD}" --workdir "${PWD}" "node:${image_tag}" \
    ash -c 'set -x; for pkg in $(sed -nr '\''s/.*"(.*)": ".*",*/\1/p'\'' package.json);do npm install --save-exact "${pkg}@latest";done && chown '"$(id -u):$(id -g)"' -R .'

# Update package-lock.json
docker run --rm -i --volume "${PWD}:${PWD}" --workdir "${PWD}" "node:${image_tag}" \
    ash -c 'npm update && chown '"$(id -u):$(id -g)"' -R .'

# If there were any changes to the Dockerfile, test it and commit them
if ! git diff --quiet package.json package-lock.json; then
    test_image
    git add package.json package-lock.json
    git commit --message "Update npm packages and its dependencies"
fi
