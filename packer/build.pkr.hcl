build {
  sources = [
    "source.googlecompute.imperva"
  ]

  provisioner "shell" {
    inline = [
      "admin",
      "curl -fSL https://github.com/aquasecurity/trivy/releases/download/v0.45.0/trivy_0.45.0_Linux-64bit.tar.gz | tar xz",
      # /usr/local/bin
      "./trivy fs --timeout 2h --scanners vuln --exit-code 1 -s HIGH,CRITICAL /",
    ]
  }

  # post-processor "vagrant" {
  # }

  # post-processor "compress" {
  #   output = "imperva.tar.gz"
  # }

  # post-processor "googlecompute-export" {
  #   paths = ["gs://imperva-image-2023/imperva.tar.gz"]
  #   keep_input_artifact = false
  # }

}
