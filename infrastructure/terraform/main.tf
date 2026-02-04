# infrastructure/terraform/main.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud SQL
resource "google_sql_database_instance" "cosif" {
  name             = "cosif-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "cosif" {
  name     = "cosif"
  instance = google_sql_database_instance.cosif.name
}

resource "google_sql_user" "cosif" {
  name     = "cosif"
  instance = google_sql_database_instance.cosif.name
  password = var.db_password
}

# Cloud Run
resource "google_cloud_run_service" "backend" {
  name     = "cosif-backend"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/cosif-backend:latest"

        env {
          name  = "DATABASE_URL"
          value = "postgres://cosif:${var.db_password}@/${google_sql_database.cosif.name}?host=/cloudsql/${google_sql_database_instance.cosif.connection_name}"
        }

        env {
          name  = "SECRET_KEY_BASE"
          value = var.secret_key_base
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }

      service_account_name = google_service_account.backend.email
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.cosif.connection_name
        "autoscaling.knative.dev/minScale"      = "1"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Service Account
resource "google_service_account" "backend" {
  account_id   = "cosif-backend"
  display_name = "COSIF Backend Service Account"
}

# IAM
resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.backend.name
  location = google_cloud_run_service.backend.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Cloud Storage for frontend
resource "google_storage_bucket" "frontend" {
  name     = "${var.project_id}-cosif-frontend"
  location = var.region

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_iam_member" "frontend_public" {
  bucket = google_storage_bucket.frontend.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

output "backend_url" {
  value = google_cloud_run_service.backend.status[0].url
}

output "frontend_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.frontend.name}/index.html"
}
