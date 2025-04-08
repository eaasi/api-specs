# SPDX-FileCopyrightText: 2025 Yale University
# SPDX-License-Identifier: Apache-2.0

# Build all required protoc plugins
FROM cgr.dev/chainguard/go:latest AS builder
WORKDIR /work
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.26.3

# Prepare a runtime container for code generation
FROM cgr.dev/chainguard/wolfi-base:latest
RUN apk update --no-cache && apk add buf
COPY --from=builder /root/go/bin/ /usr/bin/
CMD ["/usr/bin/buf", "generate", "-h"]
