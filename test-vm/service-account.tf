# This provides our Terraform service account permission to use our instance service account
# resource "google_service_account_iam_member" "admin_account_iam" {
#   service_account_id = google_service_account.vault_service_account.name
#   role               = "roles/iam.serviceAccountUser"
#   member             = "serviceAccount:${var.service_account_name}@${var.project_id}.iam.gserviceaccount.com"
# }

data "google_compute_default_service_account" "project" {
  project = "gl-compliance-governance"
}

resource "google_service_account_iam_member" "admin_account_iam" {
  service_account_id = data.google_compute_default_service_account.project.email
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:tf-service-account@gl-compliance-governance.iam.gserviceaccount.com"
}