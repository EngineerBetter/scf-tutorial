resource "google_compute_address" "uaa_ip" {
  name = "uaa"
}

output "uaa_ip" {
  value = "${google_compute_address.uaa_ip}"
}
