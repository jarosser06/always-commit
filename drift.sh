#!/bin/bash

# Script to run ai-drift using uv
# Passes all arguments to the drift command

set -e

# Install ai-drift if not already installed
uvx --from ai-drift drift "$@"
