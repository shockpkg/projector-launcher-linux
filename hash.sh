#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

cd 'build'
shasum -a 256 'main.i386' > 'main.i386.sha256'
shasum -a 256 'main.x86_64' > 'main.x86_64.sha256'
shasum -a 256 'main.sh' > 'main.sh.sha256'
