# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
ConfigDir := "./configs"

### HELPERS ###################################################################

# Run typo checker
typocheck:
  typos --config "{{ConfigDir}}/typos.toml"
