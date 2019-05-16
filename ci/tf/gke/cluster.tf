resource "google_container_cluster" "scf-cluster" {
  name               = "scf-cluster"
  initial_node_count = 1

  node_config {
    image_type   = "UBUNTU"
    machine_type = "n1-highcpu-16"
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
