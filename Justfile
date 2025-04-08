# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Directory for configuration files
ConfigDir := "./configs"

# Directory for Protobuf files
ProtoDir := "./protobuf"

# Directory for OpenAPI specs
OpenApiDir := "./openapi"

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

# Compile OpenAPI configuration
compile-configs oadir cuedir=(oadir / "cuedefs"): \
  (compile-cuedefs (cuedir) (cuedir / "grpc/config.cue") (oadir / "configs/grpc.yaml")) \
  (compile-cuedefs (cuedir) (cuedir / "openapi/config.cue") (oadir / "configs/openapi.yaml"))

# Compile OpenAPI documentation
compile-apidocs pbdir oadir: \
  (generate-openapi-v2 pbdir oadir)

# Compile OpenAPI specification
compile-openapi variant="eaasi/v1" pbdir=(ProtoDir / variant) oadir=(OpenApiDir / variant): \
  (compile-configs oadir) \
  (compile-apidocs pbdir oadir)

# Compile all OpenAPI specifications
compile-openapi-all: \
  (compile-openapi "eaasi/v1")

[private]
compile-cuedefs dir file output:
  @echo 'Compiling CUE definitions: "{{file}}" -> "{{output}}"'
  cd "{{dir}}" && just compile "{{absolute_path(file)}}" > "{{absolute_path(output)}}"
  @echo ''

[private]
generate-openapi-v2 srcdir oadir mntdir="/work":
  @echo 'Generating OpenAPI-2.0 specification: "{{srcdir}}" -> "{{oadir}}"'
  docker run --rm --tty \
    --volume "$PWD:{{mntdir}}:rw" \
    --workdir "{{clean(mntdir / oadir)}}" \
    "{{OpenApiGenName}}" buf generate \
      "{{clean(mntdir / ProtoDir)}}" \
      --path "{{clean(mntdir / srcdir)}}"
