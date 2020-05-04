#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

__self="${BASH_SOURCE[0]}"
__dir="$(cd "$(dirname "${__self}")" > /dev/null && pwd)"
__file="${__dir}/$(basename "${__self}")"

build='build'

rm -rf "${build}"
mkdir -p "${build}"

docker_tag='projector-launcher-linux'
docker build -t "${docker_tag}" 'docker'
docker run \
	--rm \
	-v "$(pwd):/src" \
	-u "$(id -u):$(id -g)" \
	-it "${docker_tag}" \
	/src/docker/compile.sh
docker rmi "${docker_tag}"

cat 'src/main.sh' | grep -v '^# ' | grep -v '^$' > "${build}/main"

chmod +x "${build}/main"*
