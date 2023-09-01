provider "google" {
  project     = "gl-compliance-governance"
  region      = "us-central1"
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wale-play-ground"

    workspaces {
      name = "gcp-imperva-waf"
    }
  }
}