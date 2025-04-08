// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

package openapi

import (
	"github.com/eaasi/api-specs/eaasi/v1:common"
)

// Custom configuration for the "protoc-gen-openapiv2" generator.
//
// For further details on all available configuration options, see also:
// https://github.com/grpc-ecosystem/grpc-gateway/blob/main/protoc-gen-openapiv2/options/openapiv2.proto
// https://github.com/grpc-ecosystem/grpc-gateway/blob/main/examples/internal/proto/examplepb/unannotated_echo_service.swagger.yaml

// OpenAPI metadata
let metadata = {
	title: "EAASI API"
	version: "0.1"
	license: {
		name: "Apache-2.0"
		url: "https://github.com/eaasi/api-specs/blob/main/LICENSE"
	}
}

// Transfer protocols
let protocols = [
	"HTTP",
	"HTTPS",
]

// Swagger configuration
let swagger_file = {
	// Attach the metadata to the anchor Protobuf file
	file: common.protobuf.module_path + "/__openapi.proto"
	option: {
		info: metadata
		schemes: protocols
	}
}

// Generator configuration
openapi_options: {
	file: [swagger_file]
}
