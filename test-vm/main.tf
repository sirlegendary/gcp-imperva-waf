# resource "google_compute_address" "static-ip" {
#   provider     = google
#   name         = "static-ip"
#   address_type = "EXTERNAL"
#   network_tier = "PREMIUM"
# }

resource "google_compute_instance" "default" {
  provider     = google
  name         = "imperva"
  machine_type = "e2-micro"
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static-ip.address
    }
  }

  metadata = {
    ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwo8gbG8rDqYJwo7P9imDwe7ZiAze1EI/LIaGXvId5upq4dXBVxCSUpLsztDWpCduk5V+hADNdjbevLdAFvVSteV3uXSTvKJ0lYrpcJ8+GWwlwDdSixKpbzZSnjAd4PNBZimJSqp2pxUPsqEB2LsyJueUPTciejfXqs+nER+jJ6F79grlaR+DBQMucx8yeO01byRCeQDVw72FdlPcFwmt5a0I6eXbWEE3cnejF79sd33fAF6GsKuMmslGKtYTJ/cj2XYyBzCqW2Tu/s7gKDC3eigWOgL6JaQSXzvedig9/pd3xdesqISsKhkn1qzN4W8jYmqjvH++Y+rQ/037Q9H3ECHIjkLgUvjynz+i2gwmCSAIkq/jfLXWMd2uuRmFcFe77FxhaQ0ycPLcRi2KJa/hxfUCt8yoDCH+uzYwraVgapJ7KU/5kJZwYU/XN3S+N8y4fwZRJmavBZRACN6kINKaR0lMvDSr6B5QdGKb1bji3PWMAitMnXJMgYo12ya832uc= walesalami@M7XMTGVH0J"
  }

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/imperva-cloud-images-public/global/images/securesphere-waf-14-4-0-16-0-39028-europe"
      #   "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
    }
  }
  # Some changes require full VM restarts
  # consider disabling this flag in production
  #   depending on your needs
  allow_stopping_for_update = true

  #   service_account {
  #     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #     email = "tf-service-account@gl-compliance-governance.iam.gserviceaccount.com"
  #     scopes = ["cloud-platform"]
  #   }
}