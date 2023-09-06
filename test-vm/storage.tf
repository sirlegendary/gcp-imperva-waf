data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }

  binding {
    role = "roles/storage.admin"
    members = [
      "user:wale.salami@globallogic.com",
    ]
  }
}

resource "google_storage_bucket" "imperva" {
  name                        = "imperva-image-2023"
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_policy" "editor" {
  bucket      = google_storage_bucket.imperva.name
  policy_data = data.google_iam_policy.viewer.policy_data
}

