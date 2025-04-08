// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

package common

let name = "eaasi"

api: {
	// Version of the API
	version: "v1alpha"

	// Separator for path components
	path_separator: "/"

	// Path prefix of the API endpoints
	path_prefix: string | *""
}

grpc: {
	// Separator for namespace components
	name_separator: "."

	// Namespace prefix for message and service definitions
	namespace_prefix: name
}

protobuf: {
	// Separator for path components
	path_separator: "/"

	// Path prefix for the Protobuf module
	module_path_prefix: name
}
