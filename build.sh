#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

build='build'
rm -rf "${build}"
mkdir -p "${build}"

cat 'src/main.sh' | grep -v '^# ' | grep -v '^$' > "${build}/main"
chmod +x "${build}/main"
