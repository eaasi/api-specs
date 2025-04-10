// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

package types

import (
	"strings"
	"github.com/eaasi/openapi-config:common"
)

// Custom HTTP pattern definition
#CustomHttpPattern: {
	kind: "GET" | "PUT" | "POST" | "PATCH" | "DELETE" | "HEAD" | "OPTIONS"
	path: string
}

// HTTP patterns supported by a HttpRule
#HttpPattern: { custom: #CustomHttpPattern } |
	{ get: string } |
	{ put: string } |
	{ post: string } |
	{ patch: string } |
	{ delete: string }

// HTTP endpoint configuration
#HttpEndpoint: {
	#HttpPattern
	body?: string
	response_body?: string
	allow_half_duplex?: bool
	additional_bindings?: [...#HttpEndpoint]
}

// A rule for mapping between a gRPC method and one or more HTTP REST endpoints, as defined in:
// https://cloud.google.com/endpoints/docs/grpc-service-config/reference/rpc/google.api#httprule
#HttpRule: {
	selector: string & =~("^" + common.grpc.namespace_prefix + ".*")
	#HttpEndpoint
}

// An alias for a list of HttpRules
#HttpRuleList: [...#HttpRule]

// An alias for a mapping between service methods and HTTP endpoints
#HttpEndpointMapping: {
	[string]: #HttpEndpoint
}

// HTTP resource definition
#HttpResource: {
	// Name of the resource
	name: string
	// HTTP endpoint prefix for use in HttpRules
	path_prefix: string | *strings.Join([common.api.path_prefix, name], common.api.path_separator)
}

// gRPC service definition
#GrpcService: {
	// Name of the service
	name: string
	// Package of the service
	package: string
	// Corresponding HTTP resource
	resource: #HttpResource
	// Mapping between methods and HTTP endpoints
	endpoints: #HttpEndpointMapping
	// Service selector prefix for use in HttpRules
	selector_prefix: string | *strings.Join([package, name, ""], common.grpc.name_separator)
	// Computed HttpRules for the provided endpoint mapping
	rules: [
		for method, endpoint in endpoints {
			// Define the method selector
			selector: selector_prefix + method
			// Pass the endpoint config as-is
			endpoint
		},
	]
}
