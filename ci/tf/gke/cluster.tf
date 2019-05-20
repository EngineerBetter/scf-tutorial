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

  name               = "scf-cluster"
  initial_node_count = 1

  master_auth {
    username = "${random_id.username.hex}"
    password = "${random_id.password.hex}"

    client_certificate_config {
      issue_client_certificate = false
    }
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
