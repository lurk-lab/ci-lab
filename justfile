# Install with `cargo install just`
# Usage: `just --dotenv-filename /path/to/file.env <bench|gpu-bench> <args>`
# TODO: Move dotenv-filename into justfile once the feature is available
set dotenv-load

commit := `git rev-parse HEAD`

# Run CUDA benchmarks on GPU
gpu-bench +benches:
  #!/bin/sh
  if [ '{{benches}}' != '' ]; then
    for bench in {{benches}}; do
      cargo criterion --bench $bench --message-format=json 2>&1 > {{commit}}.json
    done
  else
    echo "Invalid input, enter at least one non-empty string"
  fi
