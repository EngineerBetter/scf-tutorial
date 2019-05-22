resource "google_project_service" "dns" {
  service                    = "dns.googleapis.com"
  disable_dependent_services = true
}

resource "google_dns_managed_zone" "scf" {
  name        = "scf"
  dns_name    = "scf.engineerbetter.com."
  description = "DNS zone for SCF tutorial"

  depends_on = [
    "google_project_service.dns",
  ]
}

output "scf_name_servers" {
  value = "${google_dns_managed_zone.scf.name_servers}"
}
