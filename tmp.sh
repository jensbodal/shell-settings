#!/bin/bash
# usage: ./bench.sh llama3:8b-instruct
set -euo pipefail

PROMPT='Write exactly 300 tokens describing how to build a
RAG pipeline with embeddings, a vector DB, and an agent
that calls a SQL tool. End with the word "END".'

tmp="$(mktemp)"

#models=(llama2 mistral:7b phi3)
models=(phi3)

for m in "${models[@]}"; do
  ollama pull "$m"                # pulls once, reuses later
  stats=$(ollama run "$m" --verbose --keepalive=0m "$PROMPT" | grep '^stats')
  echo "$HOSTNAME,$m,$stats" >> bench.csv
done
time ollama run "$1" "$PROMPT" --verbose | tee /tmp/bench.log
