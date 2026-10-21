terraform {
  required_version = ">= 1.5"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "apis" {
  for_each           = toset(["run.googleapis.com", "artifactregistry.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "ml-inference-demo"
  format        = "DOCKER"
  depends_on    = [google_project_service.apis]
}

resource "google_service_account" "run" {
  account_id   = "ml-inference-demo-run"
  display_name = "Cloud Run runtime SA (least privilege)"
}

resource "google_cloud_run_v2_service" "app" {
  name     = "ml-inference-demo"
  location = var.region

  template {
    service_account = google_service_account.run.email
    scaling {
      min_instance_count = 0
      max_instance_count = var.max_instances
    }
    containers {
      image = var.image
      ports { container_port = 8080 }
      resources {
        limits = { cpu = "1", memory = "512Mi" }
      }
      startup_probe {
        http_get { path = "/healthz" }
      }
      liveness_probe {
        http_get { path = "/healthz" }
      }
    }
  }
  depends_on = [google_project_service.apis]
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  count    = var.allow_public ? 1 : 0
  name     = google_cloud_run_v2_service.app.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
