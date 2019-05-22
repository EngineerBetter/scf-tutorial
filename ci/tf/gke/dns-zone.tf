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

resource "google_dns_record_set" "uaa" {
  name = "uaa.${google_dns_managed_zone.scf.dns_name}"
  type = "A"
  ttl  = 5

  managed_zone = "${google_dns_managed_zone.scf.name}"

  rrdatas = ["${google_compute_address.uaa_ip.address}"]
}

resource "google_dns_record_set" "scf_uaa_zone" {
  name = "scf.uaa.${google_dns_managed_zone.scf.dns_name}"
  type = "A"
  ttl  = 5

  managed_zone = "${google_dns_managed_zone.scf.name}"

  rrdatas = ["${google_compute_address.uaa_ip.address}"]
}

resource "google_dns_record_set" "ssh" {
  name = "ssh.${google_dns_managed_zone.scf.dns_name}"
  type = "A"
  ttl  = 5

  managed_zone = "${google_dns_managed_zone.scf.name}"

  rrdatas = ["${google_compute_address.ssh_ip.address}"]
}

resource "google_dns_record_set" "router" {
  name = "*.${google_dns_managed_zone.scf.dns_name}"
  type = "A"
  ttl  = 5

  managed_zone = "${google_dns_managed_zone.scf.name}"

  rrdatas = ["${google_compute_address.router_ip.address}"]
}
