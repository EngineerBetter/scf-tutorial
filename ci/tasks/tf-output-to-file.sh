#!/bin/bash

set -euo pipefail

: "${METADATA_KEY:?METADATA_KEY env var must be provide the key name to look up in metadata}"
: "${OUTPUT_FILE:?OUTPUT_FILE env var must provide full name of file to write into tf-output-to-file output dir}"

jq -r ".${METADATA_KEY}" terraform/metadata > tf-output-to-file/"${OUTPUT_FILE}"
