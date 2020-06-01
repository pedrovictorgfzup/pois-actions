#!/bin/sh

set -e

echo $1
ruby /action/lib/ci_linter_helper.rb $1