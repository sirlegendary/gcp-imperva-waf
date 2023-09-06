data "google_compute_default_service_account" "project" {
  project = "gl-compliance-governance"
}

resource "google_service_account_iam_member" "admin_account_iam" {
  service_account_id = data.google_compute_default_service_account.project.email
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:tf-service-account@gl-compliance-governance.iam.gserviceaccount.com"
}