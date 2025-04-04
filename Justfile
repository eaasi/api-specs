# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
config_dir := "./configs"

# Directory for Protobuf files
proto_dir := "./protos"

### HELPERS ###################################################################

# Run typo checker
typocheck:
  typos --config "{{ config_dir }}/typos.toml"

### BUF #######################################################################

# Run Buf's linter
lint input=proto_dir:
  buf lint "{{ input }}"
