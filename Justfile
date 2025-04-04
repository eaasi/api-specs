# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
config_dir := "./configs"

### HELPERS ###################################################################

# Run typo checker
typocheck:
  typos --config "{{ config_dir }}/typos.toml"
