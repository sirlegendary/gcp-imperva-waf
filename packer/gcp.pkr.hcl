source "googlecompute" "imperva" {
  project_id                      = "gl-compliance-governance"
  zone                            = "europe-west1-b"
  source_image_project_id         = ["imperva-cloud-images-public"]
  source_image                    = "securesphere-waf-14-4-0-16-0-39028-europe"
  disk_size                       = "160"
  ssh_username                    = "root"
  disable_default_service_account = true
  use_os_login                    = false
}
