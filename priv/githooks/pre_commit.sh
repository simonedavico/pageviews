#!/bin/sh

# Run format and credo checks before commit 

# run mix format
git diff --name-only --cached | grep -E ".*\.(ex|exs)$" | xargs mix format --check-formatted

# run mix credo
git diff --name-only --cached | xargs mix credo --strict