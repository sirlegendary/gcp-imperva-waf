source "googlecompute" "imperva" {
    project_id = "gl-compliance-governance"
    source_image = "https://www.googleapis.com/compute/v1/projects/imperva-cloud-images-public/global/images/securesphere-waf-14-4-0-16-0-39028-europe"
    zone = "europe-west1-b"
    ssh_username = "root" 
}
