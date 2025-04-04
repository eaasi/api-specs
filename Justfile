# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
ConfigDir := "./configs"

# Directory for Protobuf files
ProtoDir := "./protobuf"

### HELPERS ###################################################################

# Run typo checker
typocheck:
  typos --config "{{ConfigDir}}/typos.toml"

### BUF #######################################################################

# Run Buf's linter
lint input=ProtoDir:
  buf lint "{{input}}"
