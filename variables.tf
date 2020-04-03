/**
 * Copyright 2020 Quortex
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type        = string
  description = "The GCP project in which to create resources."
}

variable "region" {
  type        = string
  description = "The region in wich to create regional resources."
}

variable "public_ip_name" {
  type        = string
  description = "The public load balancer external IP name."
  default     = "quortex-public"
}

variable "public_ip_description" {
  type        = string
  description = "A description for the public load balancer external IP."
  default     = "Quortex public load balancer IP."
}

variable "public_ip_version" {
  type        = string
  description = "The IP Version that will be used by the public load balancer address."
  default     = "IPV4"
}

variable "public_http_forwarding_rule_name" {
  type        = string
  description = "The public load balancer http forwarding rule name."
  default     = "quortex-public-http"
}

variable "public_http_forwarding_rule_description" {
  type        = string
  description = "A description for the public load balancer http forwarding rule."
  default     = "Quortex public load balancer HTTP forwarding rule."
}

variable "public_https_forwarding_rule_name" {
  type        = string
  description = "The public load balancer https forwarding rule name."
  default     = "quortex-public-https"
}

variable "public_https_forwarding_rule_description" {
  type        = string
  description = "A description for the public load balancer https forwarding rule."
  default     = "Quortex public load balancer HTTPS forwarding rule."
}

variable "public_http_proxy_name" {
  type        = string
  description = "The public load balancer http proxy name."
  default     = "quortex-public-http"
}

variable "public_http_proxy_description" {
  type        = string
  description = "A description for the public load balancer http proxy."
  default     = "Quortex public load balancer HTTP proxy."
}

variable "public_https_proxy_name" {
  type        = string
  description = "The public load balancer https proxy name."
  default     = "quortex-public-https"
}

variable "public_https_proxy_description" {
  type        = string
  description = "A description for the public load balancer https proxy."
  default     = "Quortex public load balancer HTTPS proxy."
}

variable "public_url_map_name" {
  type        = string
  description = "The public load balancer url map name."
  default     = "quortex-public"
}

variable "public_url_map_description" {
  type        = string
  description = "A description for the public load balancer url map."
  default     = "Quortex public load balancer url map."
}

variable "public_backend_service_name" {
  type        = string
  description = "The public load balancer backend service name."
  default     = "quortex-public"
}

variable "public_backend_service_description" {
  type        = string
  description = "A description for the public load balancer backend service."
  default     = "Quortex public load balancer url map."
}

variable "public_backend_service_config" {
  type        = list
  description = "The backend configuration for public loadbalancer backend. The available keys follows backend configuration described here => https://www.terraform.io/docs/providers/google/r/compute_backend_service.html#backend."
  default     = []
}

variable "public_http_health_check_name" {
  type        = string
  description = "The public load balancer backend service http health check name."
  default     = "quortex-public"
}

variable "public_http_health_check_description" {
  type        = string
  description = "A description for the public load balancer backend service http health check."
  default     = "Quortex public load balancer backend service http health check."
}

variable "public_http_health_check_config" {
  type = object({
    port         = number
    request_path = string
  })
  description = "The public http health check configuration (port and request path)."
}

variable "private_ip_name" {
  type        = string
  description = "The private load balancer external IP name."
  default     = "quortex-private"
}

variable "private_ip_description" {
  type        = string
  description = "A description for the private load balancer external IP."
  default     = "Quortex private load balancer IP."
}

variable "private_ip_version" {
  type        = string
  description = "The IP Version that will be used by the private load balancer address."
  default     = "IPV4"
}

variable "private_http_forwarding_rule_name" {
  type        = string
  description = "The private load balancer http forwarding rule name."
  default     = "quortex-private-http"
}

variable "private_http_forwarding_rule_description" {
  type        = string
  description = "A description for the private load balancer http forwarding rule."
  default     = "Quortex private load balancer HTTP forwarding rule."
}

variable "private_https_forwarding_rule_name" {
  type        = string
  description = "The private load balancer https forwarding rule name."
  default     = "quortex-private-https"
}

variable "private_https_forwarding_rule_description" {
  type        = string
  description = "A description for the private load balancer https forwarding rule."
  default     = "Quortex private load balancer HTTPS forwarding rule."
}

variable "private_http_proxy_name" {
  type        = string
  description = "The private load balancer http proxy name."
  default     = "quortex-private-http"
}

variable "private_http_proxy_description" {
  type        = string
  description = "A description for the private load balancer http proxy."
  default     = "Quortex private load balancer HTTP proxy."
}

variable "private_https_proxy_name" {
  type        = string
  description = "The private load balancer https proxy name."
  default     = "quortex-private-https"
}

variable "private_https_proxy_description" {
  type        = string
  description = "A description for the private load balancer https proxy."
  default     = "Quortex private load balancer HTTPS proxy."
}

variable "private_url_map_name" {
  type        = string
  description = "The private load balancer url map name."
  default     = "quortex-private"
}

variable "private_url_map_description" {
  type        = string
  description = "A description for the private load balancer url map."
  default     = "Quortex private load balancer url map."
}

variable "private_backend_service_name" {
  type        = string
  description = "The private load balancer backend service name."
  default     = "quortex-private"
}

variable "private_backend_service_description" {
  type        = string
  description = "A description for the private load balancer backend service."
  default     = "Quortex private load balancer url map."
}

variable "private_backend_service_config" {
  type        = list
  description = "The backend configuration for private loadbalancer backend. The available keys follows backend configuration described here => https://www.terraform.io/docs/providers/google/r/compute_backend_service.html#backend."
  default     = []
}

variable "private_http_health_check_name" {
  type        = string
  description = "The private load balancer backend service http health check name."
  default     = "quortex-private"
}

variable "private_http_health_check_description" {
  type        = string
  description = "A description for the private load balancer backend service http health check."
  default     = "Quortex private load balancer backend service http health check."
}

variable "private_http_health_check_config" {
  type = object({
    port         = number
    request_path = string
  })
  description = "The private http health check configuration (port and request path)."
}

variable "private_security_policy_name" {
  type        = string
  description = "The private load balancer backend service security policy name."
  default     = "quortex-private"
}

variable "private_security_policy_description" {
  type        = string
  description = "A description for the private load balancer backend service security policy."
  default     = "Quortex private load balancer backend service security policy."
}

variable "private_security_policy_whitelisted_ips" {
  type        = list(string)
  description = "A list of IP ranges to whitelist for private load balancer access."
  default     = []
}

variable "dns_managed_zone" {
  type        = string
  description = "The name of an available DNS zone in which to create DNS records."
}

variable "dns_records_private" {
  type        = map(string)
  description = "A map with dns records to add in dns_managed_zone for private endpoints set as value. Full domain names will be exported in a map for the given key."
  default     = {}
}

variable "dns_records_public" {
  type        = map(string)
  description = "A map with dns records to add in dns_managed_zone for public endpoints set as value. Full domain names will be exported in a map for the given key."
  default     = {}
}

variable "ssl_certificates_name_prefix" {
  type        = string
  description = "A prefix for compute managed SSL certificates names. Managed SSL certificates names will be computed from this prefix and the associated DNS record."
  default     = "quortex"
}

variable "labels" {
  type        = map
  description = "Labels to apply to resources. A list of key->value pairs."
  default     = {}
}
