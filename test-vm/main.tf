resource "google_compute_instance" "default" {
  provider     = google
  name         = "imperva-playground"
  machine_type = "e2-micro"
  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwo8gbG8rDqYJwo7P9imDwe7ZiAze1EI/LIaGXvId5upq4dXBVxCSUpLsztDWpCduk5V+hADNdjbevLdAFvVSteV3uXSTvKJ0lYrpcJ8+GWwlwDdSixKpbzZSnjAd4PNBZimJSqp2pxUPsqEB2LsyJueUPTciejfXqs+nER+jJ6F79grlaR+DBQMucx8yeO01byRCeQDVw72FdlPcFwmt5a0I6eXbWEE3cnejF79sd33fAF6GsKuMmslGKtYTJ/cj2XYyBzCqW2Tu/s7gKDC3eigWOgL6JaQSXzvedig9/pd3xdesqISsKhkn1qzN4W8jYmqjvH++Y+rQ/037Q9H3ECHIjkLgUvjynz+i2gwmCSAIkq/jfLXWMd2uuRmFcFe77FxhaQ0ycPLcRi2KJa/hxfUCt8yoDCH+uzYwraVgapJ7KU/5kJZwYU/XN3S+N8y4fwZRJmavBZRACN6kINKaR0lMvDSr6B5QdGKb1bji3PWMAitMnXJMgYo12ya832uc= walesalami@M7XMTGVH0J"
  }

  boot_disk {
    initialize_params {
      size  = 250
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
    }
  }

  # allow_stopping_for_update = true

  metadata_startup_script = "./setup.sh"
}

resource "google_compute_firewall" "wetty" {
  name    = "imperva-wetty"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }
  source_ranges = ["0.0.0.0/0"]
}

