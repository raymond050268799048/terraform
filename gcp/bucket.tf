resource "google_logging_project_bucket_config" "analytics-enabled-bucket" {
    project          = var.project_id
    location         = "global"
    retention_days   = 30
    bucket_id        = "1_Default2"
}
