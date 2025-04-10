// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

package adminsvc

import (
	"github.com/eaasi/api-specs/eaasi/v1alpha/grpc:types"
)

// HTTP resource for the AdminService
let http_resource = types.#HttpResource & {
	name: "admin"
}

// Prefix for the API endpoints
let ep = http_resource.path_prefix

// Mapping between AdminService's methods and HTTP endpoints
let http_endpoints = types.#HttpEndpointMapping & {
	"GetBuildInfo": {
		get: ep + "/build-info"
	}
}

// AdminService's configuration
grpc: types.#GrpcService & {
	package: "eaasi.admin.v1alpha"
	name: "AdminService"
	resource: http_resource
	endpoints: http_endpoints
}
