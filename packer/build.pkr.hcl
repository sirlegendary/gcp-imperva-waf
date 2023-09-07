build {
  sources = [
    "source.googlecompute.imperva"
  ]

  provisioner "shell" {
    inline = [
      "apt-get update -qq",
      "apt-get install -qq -y python3 python3-pip curl jq",
      "apt-get upgrade -y -qq",
      "curl -fSL https://github.com/aquasecurity/trivy/releases/download/v0.45.0/trivy_0.45.0_Linux-64bit.tar.gz | tar xz",
      "./trivy fs --exit-code 1 -s HIGH,CRITICAL /",
      "apt-get clean all"
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
