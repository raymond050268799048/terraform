resource "google_logging_project_bucket_config" "logging_log_view" {
    project        = var.project_id
    location       = "global"
    retention_days = 60
    bucket_id      = "_Default"
}

resource "google_logging_log_view" "logging_log_view" {
  name        = "view1"
  bucket      = google_logging_project_bucket_config.logging_log_view.id
  description = "A logging view"
  filter      = "SOURCE(\"projects/myproject\") AND resource.type = \"gce_instance\" AND LOG_ID(\"stdout\")"
}