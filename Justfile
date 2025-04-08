# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
ConfigDir := "./configs"

# Directory for Protobuf files
ProtoDir := "./protobuf"

# Docker image name for the OpenAPI generator
OpenApiGenName := "eaasi-openapi-generator"

### HELPERS ###################################################################

# Run typo checker
typocheck:
  typos --config "{{ConfigDir}}/typos.toml"

### BUF #######################################################################

# Run Buf's linter
lint input=ProtoDir:
  buf lint "{{input}}"

# Run Buf's breaking change detector
breaking against=".git#branch=main" input=ProtoDir:
  buf breaking "{{input}}" --against "{{against}}"

# List all Protobuf files
list-protos input=ProtoDir:
  buf ls-files "{{input}}"

### OPENAPI ###################################################################

# Prepare OpenAPI generator runtime
prepare-generator:
  docker build --tag "{{OpenApiGenName}}" .
