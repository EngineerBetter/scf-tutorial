resource "random_id" "username" {
  byte_length = 14
}

resource "random_id" "password" {
  byte_length = 16
}

resource "google_project_service" "compute" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  service                    = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_container_cluster" "scf-cluster" {
  depends_on = [
    "google_project_service.compute",
    "google_project_service.container",
  ]

  name                     = "scf-cluster"
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = "${random_id.username.hex}"
    password = "${random_id.password.hex}"

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "scf-nodes"
  cluster    = "${google_container_cluster.scf-cluster.name}"
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "n1-standard-32"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/kubeconfig-template.yaml")}"

  vars {
    cluster_name    = "${google_container_cluster.scf-cluster.name}"
    user_name       = "${google_container_cluster.scf-cluster.master_auth.0.username}"
    user_password   = "${google_container_cluster.scf-cluster.master_auth.0.password}"
    endpoint        = "${google_container_cluster.scf-cluster.endpoint}"
    cluster_ca      = "${google_container_cluster.scf-cluster.master_auth.0.cluster_ca_certificate}"
    client_cert     = "${google_container_cluster.scf-cluster.master_auth.0.client_certificate}"
    client_cert_key = "${google_container_cluster.scf-cluster.master_auth.0.client_key}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.module}/kubeconfig"
}

output "kubeconfig_content" {
  value     = "${local_file.kubeconfig.content}"
  sensitive = true
}
