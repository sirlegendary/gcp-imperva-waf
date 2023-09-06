build {
  sources = [
    "source.googlecompute.imperva"
  ]

  post-processor "vagrant" {
  }

  post-processor "compress" {
    output = "imperva.tar.gz"
  }

  post-processor "googlecompute-export" {
    paths = ["gs://imperva-image-2023/imperva.tar.gz"]
    keep_input_artifact = false
  }

}
