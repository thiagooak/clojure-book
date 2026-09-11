#!/usr/bin/env bash
# Builds book.adoc to build/book.html with Asciidoctor.
#
# Falls back to the user-install gem bin dir if `asciidoctor` isn't on
# PATH — `gem install --user-install` on a stock macOS Ruby doesn't put
# it there by default.
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p build

if command -v asciidoctor >/dev/null 2>&1; then
  ASCIIDOCTOR=asciidoctor
else
  ASCIIDOCTOR="$(gem environment gemdir)/../../bin/asciidoctor"
  USER_BIN="$HOME/.gem/ruby/$(ruby -e 'print RUBY_VERSION.sub(/\d+$/, "0")')/bin/asciidoctor"
  [ -x "$USER_BIN" ] && ASCIIDOCTOR="$USER_BIN"
fi

"$ASCIIDOCTOR" \
  --failure-level=WARN \
  -o build/book.html \
  book.adoc

echo "Built build/book.html"
