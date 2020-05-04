#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

__self="${BASH_SOURCE[0]}"
__dir="$(cd "$(dirname "${__self}")" > /dev/null && pwd)"
__file="${__dir}/$(basename "${__self}")"

cd "${__dir}/.."

build='build'
mkdir -p "${build}"

gcc -Wall -m32 -O3 -s -o "${build}/main.i386"   'src/main.c'
strip -sgSd "${build}/main.i386"

gcc -Wall -m64 -O3 -s -o "${build}/main.x86_64" 'src/main.c'
strip -sgSd "${build}/main.x86_64"
