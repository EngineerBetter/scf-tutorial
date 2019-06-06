resource "google_compute_address" "uaa_ip" {
  name = "uaa"
}

output "uaa_ip" {
  value = "${google_compute_address.uaa_ip.address}"
}

resource "google_compute_address" "ssh_ip" {
  name = "ssh"
}

output "ssh_ip" {
  value = "${google_compute_address.ssh_ip.address}"
}

resource "google_compute_address" "router_ip" {
  name = "router"
}

output "router_ip" {
  value = "${google_compute_address.router_ip.address}"
}

resource "google_compute_address" "stratos_ip" {
  name = "stratos"
}

output "stratos_ip" {
  value = "${google_compute_address.stratos_ip.address}"
}
