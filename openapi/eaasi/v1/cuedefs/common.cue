// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

package common

import "strings"

let name = "eaasi"

api: {
	// Version of the API
	version: "v1"
	// Separator for path components
	path_separator: "/"
	// Path prefix of the API endpoints
	path_prefix: path_separator + version
}

grpc: {
	// Separator for namespace components
	name_separator: "."
	// Namespace for message and service definitions
	namespace: strings.Join([name, api.version], name_separator)
}

protobuf: {
	// Path for the Protobuf module
	module_path: strings.Join([name, api.version], "/")
}
