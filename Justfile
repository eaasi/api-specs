# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
config_dir := "./configs"

# Directory for Protobuf files
proto_dir := "./protos"

# Directory for OpenAPI specs
openapi_dir := "./openapi"

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

# Compile OpenAPI configuration
compile-configs dir cuedir=(dir / "cuedefs") outdir=(dir / "configs"): \
  (compile-cuedefs (cuedir) (cuedir / "grpc" / "config.cue") (outdir / "grpc.yaml")) \
  (compile-cuedefs (cuedir) (cuedir / "openapi" / "config.cue") (outdir / "openapi.yaml"))

# Compile OpenAPI documentation
compile-apidocs dir: \
  (generate-openapi-v2 dir)

# Compile OpenAPI specification
compile-openapi variant="eaasi/v1alpha" dir=(openapi_dir / variant): \
  (compile-configs dir) \
  (compile-apidocs dir)

# Compile all OpenAPI specifications
compile-openapi-all: \
  (compile-openapi "eaasi/v1alpha")

[private]
compile-cuedefs dir file output:
  @echo 'Compiling CUE definitions: "{{ file }}" -> "{{ output }}"'
  cd "{{ dir }}" && just compile "{{ absolute_path(file) }}" > "{{ absolute_path(output) }}"
  @echo ''

[private]
generate-openapi-v2 dir mntdir="/work":
  @echo 'Generating OpenAPI-2.0 specification: "{{ dir }}"'
  docker run --rm --tty \
    --volume "$PWD:{{ mntdir }}:rw" \
    --workdir "{{ mntdir }}" \
    "{{ openapi_gen_name }}" buf generate \
        --config "./buf.yaml" \
        --template "{{ dir / "buf.gen.yaml" }}"
