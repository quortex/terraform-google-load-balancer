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

locals {
  # Remove the point at the end of private fqdns.
  private_domains = { for k, v in google_dns_record_set.private : k => regex("(.*).$", v.name)[0] }
  # Remove the point at the end of public fqdns.
  public_domains = { for k, v in google_dns_record_set.public : k => regex("(.*).$", v.name)[0] }
}

# Get the provided managed zone reference.
data "google_dns_managed_zone" "zone" {
  provider = google-beta
  name     = var.dns_managed_zone
}

# A list of DNS records for public purpose.
resource "google_dns_record_set" "public" {
  for_each = var.dns_records_public

  name = "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = var.dns_managed_zone

  rrdatas = [google_compute_global_address.public.address]
}

# A list of DNS records for private purpose.
resource "google_dns_record_set" "private" {
  for_each = var.dns_records_private

  name = "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = var.dns_managed_zone

  rrdatas = [google_compute_global_address.private.address]
}

# SSL certificates for public domains.
resource "google_compute_managed_ssl_certificate" "public" {
  provider = google-beta
  for_each = var.dns_records_public

  name = replace("${var.ssl_certificates_name_prefix}-${each.key}", ".", "-")

  managed {
    domains = [google_dns_record_set.public[each.key].name]
  }
}

# SSL certificates for private domains.
resource "google_compute_managed_ssl_certificate" "private" {
  provider = google-beta
  for_each = var.dns_records_private

  name = replace("${var.ssl_certificates_name_prefix}-${each.key}", ".", "-")

  managed {
    domains = [google_dns_record_set.private[each.key].name]
  }
}
