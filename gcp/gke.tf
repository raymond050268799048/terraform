variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

resource "google_container_cluster" "primary" {
  name     = "ea2-gke"
  location = var.region
  
  remove_default_node_pool = true
  initial_node_count       = 1
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  cluster_autoscaling{
  enabled = true
  resource_limits{
    resource_type = "cpu"
    minimum       = 1
    maximum       = 4
    }
  resource_limits{ 
    resource_type = "memory"
    minimum       = 1
    maximum       = 4
  }
   
  }
}


resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes


    node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    disk_size_gb  = 30
    labels = {
      env = "ea2"
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "ea2-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
