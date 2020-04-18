#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

cd 'build'
shasum -a 256 'main' > 'main.sha256'
