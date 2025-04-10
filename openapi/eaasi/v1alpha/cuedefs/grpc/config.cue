// SPDX-FileCopyrightText: 2025 Yale University
// SPDX-License-Identifier: Apache-2.0

import (
	"list"
	"github.com/eaasi/openapi-config/grpc:types"
	"github.com/eaasi/openapi-config/grpc/services:services"
)

// HTTP rules for the gRPC API Configuration.
//
// For the upstream documentation and further details, see also:
// https://grpc-ecosystem.github.io/grpc-gateway/docs/mapping/grpc_api_configuration/
// https://cloud.google.com/endpoints/docs/grpc-service-config/reference/rpc/google.api#httprule

let http_rules = list.Concat([
	services.#AdminService.rules
]) & types.#HttpRuleList

type: "google.api.Service"
config_version: 3
http: {
	rules: http_rules
}
