source "googlecompute" "imperva" {
    project_id = "gl-compliance-governance"
    source_image_project_id = "imperva-cloud-images-public"
    source_image = "securesphere-waf-14-4-0-16-0-39028-europe"
    zone = "europe-west1-b"
    ssh_username = "root" 
}
