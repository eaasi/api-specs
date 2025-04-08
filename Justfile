# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
config_dir := "./configs"

# Directory for Protobuf files
proto_dir := "./protos"

# Docker image name for the OpenAPI generator
openapi_gen_name := "eaasi-openapi-generator"

### HELPERS ###################################################################

# Run typo checker
typocheck:
  typos --config "{{ config_dir }}/typos.toml"

### BUF #######################################################################

# Run Buf's linter
lint input=proto_dir:
  buf lint "{{ input }}"

# Run Buf's breaking change detector
breaking against=".git#branch=main" input=proto_dir:
  buf breaking "{{ input }}" --against "{{ against }}"

# List all Protobuf files
list-protos input=proto_dir:
  buf ls-files "{{ input }}"

### OPENAPI ###################################################################

# Prepare OpenAPI generator runtime
prepare-generator:
  docker build --tag "{{ openapi_gen_name }}" .
