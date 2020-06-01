#!/bin/sh

set -e

echo $1
rubocop --version
ruby /action/lib/ci_linter_helper.rb $1