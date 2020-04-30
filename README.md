[![Quortex][logo]](https://quortex.io)
# terraform-google-load-balancer
A terraform module for Quortex infrastructure GCP load balancing layer.

It provides a set of resources necessary to provision the Quortex infrastructure load balancers, DNS and ssl certificates.

This module is available on [Terraform Registry][registry_tf_google_load_balancer].

Get all our terraform modules on [Terraform Registry][registry_tf_modules] or on [Github][github_tf_modules] !

## Created resources

This module creates the following resources in GCP:

- a HTTPS load balancer for public traffic (live)
- a HTTPS load balancer for internal traffic (administration)
- a list of DNS records
- SSL certificates for each record


## Usage example

```hcl
module "load-balancer" {
  source  = "quortex/load-balancer/google"

  # Globally used variables.
  project_id = module.network.project_id
  region     = "europe-west1"

  # Prevent resources names conflicts for multiple workspaces usage.
  private_backend_service_name       = "quortex-${terraform.workspace}-private"
  private_http_forwarding_rule_name  = "quortex-${terraform.workspace}-private-http"
  private_http_health_check_name     = "quortex-${terraform.workspace}-private"
  private_http_proxy_name            = "quortex-${terraform.workspace}-private-http"
  private_https_forwarding_rule_name = "quortex-${terraform.workspace}-private-https"
  private_https_proxy_name           = "quortex-${terraform.workspace}-private-https"
  private_ip_name                    = "quortex-${terraform.workspace}-private"
  private_security_policy_name       = "quortex-${terraform.workspace}-private"
  private_url_map_name               = "quortex-${terraform.workspace}-private"
  public_backend_service_name        = "quortex-${terraform.workspace}-public"
  public_http_forwarding_rule_name   = "quortex-${terraform.workspace}-public-http"
  public_http_health_check_name      = "quortex-${terraform.workspace}-public"
  public_http_proxy_name             = "quortex-${terraform.workspace}-public-http"
  public_https_forwarding_rule_name  = "quortex-${terraform.workspace}-public-https"
  public_https_proxy_name            = "quortex-${terraform.workspace}-public-https"
  public_ip_name                     = "quortex-${terraform.workspace}-public"
  public_url_map_name                = "quortex-${terraform.workspace}-public"

  # The http health checks configuration (set for traefik ingress controllers).
  private_http_health_check_config = {
    port         = 80
    request_path = "/ping"
  }
  public_http_health_check_config = {
    port         = 80
    request_path = "/ping"
  }

  # DNS configuration
  dns_managed_zone = "quortex-zone"
  dns_records_public = {
    live = "live.${terraform.workspace}"
  }
  dns_records_private = {
    api     = "api.${terraform.workspace}"
    grafana = "grafana.${terraform.workspace}"
    weave   = "weave.${terraform.workspace}"
  }

  # A list of IP ranges to whitelist for private load balancer access.
  private_security_policy_whitelisted_ips = ["147.178.103.209/32"]

  # The backend configuration for private loadbalancer backend.
  # The available keys follows backend configuration described here => https://www.terraform.io/docs/providers/google/r/compute_backend_service.html#backend.
  private_backend_service_config = [
    for _, v in data.google_compute_network_endpoint_group.private : {
      group          = v.self_link
      balancing_mode = "RATE"
      max_rate       = 100
    }
  ]
  # The backend configuration for public loadbalancer backend.
  # The available keys follows backend configuration described here => https://www.terraform.io/docs/providers/google/r/compute_backend_service.html#backend.
  public_backend_service_config = [
    for _, v in data.google_compute_network_endpoint_group.public : {
      group          = v.self_link
      balancing_mode = "RATE"
      max_rate       = 100
    }
  ]
}
```

---

## Related Projects

This project is part of our terraform modules to provision a Quortex infrastructure for Google Cloud Platform.

![infra_gcp]

Check out these related projects.

- [terraform-google-network][registry_tf_google_network] - A terraform module for Quortex infrastructure network layer.

- [terraform-google-gke-cluster][registry_tf_google_gke_cluster] - A terraform module for Quortex infrastructure GKE cluster layer.

- [terraform-google-storage][registry_tf_google_storage] - A terraform module for Quortex infrastructure GCP persistent storage layer.

## Help

**Got a question?**

File a GitHub [issue](https://github.com/quortex/terraform-google-load-balancer/issues) or send us an [email][email].


  [logo]: https://storage.googleapis.com/quortex-assets/logo.webp
  [email]: mailto:info@quortex.io
  [infra_gcp]: https://storage.googleapis.com/quortex-assets/infra_gcp_002.jpg
  [registry_tf_modules]: https://registry.terraform.io/modules/quortex
  [registry_tf_google_network]: https://registry.terraform.io/modules/quortex/network/google
  [registry_tf_google_gke_cluster]: https://registry.terraform.io/modules/quortex/gke-cluster/google
  [registry_tf_google_load_balancer]: https://registry.terraform.io/modules/quortex/load-balancer/google
  [registry_tf_google_storage]: https://registry.terraform.io/modules/quortex/storage/google
  [github_tf_modules]: https://github.com/quortex?q=terraform-