#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p build

# brew install asciidoctor && gem install rouge
asciidoctor \
  --failure-level=WARN \
  -o build/book.html \
  book.adoc

echo "Built build/book.html"
