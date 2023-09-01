provider "google" {
  project     = "gl-compliance-governance"
  region      = "europe-west-1"
  zone        = "europe-west1-b"
  credentials = var.gcp-creds
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "wale-play-ground"

    workspaces {
      name = "gcp-imperva-waf-test"
    }
  }
}