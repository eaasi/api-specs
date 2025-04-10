// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

package grpc

import (
	"list"
	"github.com/eaasi/api-specs/eaasi/v1alpha/grpc:types"
	"github.com/eaasi/api-specs/eaasi/v1alpha/grpc/services:adminsvc"
)

// HTTP rules for the gRPC API Configuration.
//
// For the upstream documentation and further details, see also:
// https://grpc-ecosystem.github.io/grpc-gateway/docs/mapping/grpc_api_configuration/
// https://cloud.google.com/endpoints/docs/grpc-service-config/reference/rpc/google.api#httprule

let http_rules = list.Concat([
	adminsvc.grpc.rules
]) & types.#HttpRuleList

type: "google.api.Service"
config_version: 3
http: {
	rules: http_rules
}
