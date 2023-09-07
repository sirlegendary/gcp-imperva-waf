build {
  sources = [
    "source.googlecompute.imperva"
  ]

  provisioner "file" {
    source = "files"
    destination = "/root"
  }

  provisioner "shell" {
    inline = [
      "curl -fSL https://github.com/aquasecurity/trivy/releases/download/v0.45.0/trivy_0.45.0_Linux-64bit.tar.gz | tar xz -C /usr/local/bin"
      "trivy fs --timeout 2h --ignorefile /root/.trivyignore.yaml --scanners vuln --exit-code 1 -s HIGH,CRITICAL /",
    ]
  }
}
