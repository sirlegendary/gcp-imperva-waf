provider "google" {
  project = var.project_id
  region = var.region
}

variable "deployment_name" {
  type = string
  description = "Enter a deployment identifier. This identifier will be a prefix for all deployed resources"
  validation {
    condition = can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.deployment_name))
    error_message = "Must consist of lowercase letters (a-z), numbers, and hyphens."
  }
}

variable "region" {
  type = string
  description = "Enter the target region for all regional resources"
  validation {
    condition = can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.region))
    error_message = "Must consist of lowercase letters (a-z), numbers, and hyphens."
  }
}

variable "vpc_network" {
  type = string
  description = "Enter the name of your target VPC network"
  validation {
    condition = can(regex("^[a-z].*", var.vpc_network))
    error_message = "Must begin with a lowercase letter."
  }
}

variable "timezone" {
  type = string
  description = "Select the desired timezone for all deployed instances"
}

variable "project_id" {
  type = string
  description = "Enter the target GCP project ID"
  validation {
    condition = can(regex("^[a-z].*", var.project_id))
    error_message = "Must begin with a lowercase letter."
  }
}

variable "block_project_ssh_keys" {
  type = bool
  description = "When checked, project-wide SSH keys cannot access all deployed instances"
}

variable "ui_access_source_ranges" {
  type = list
  description = "Specify a set of comma-separated source IP ranges in CIDR format for UI access via port 8083 (e.g. 10.0.1.0/24)"
  validation {
    condition = alltrue([for range in var.ui_access_source_ranges: can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(3[0-2]|[1-2][0-9]|[0-9]))$", range))])
    error_message = "One or more invalid IP ranges."
  }
}

variable "ssh_access_source_ranges" {
  type = list
  description = "Specify a set of comma-separated source IP ranges in CIDR format for SSH access via port 22 (e.g. 10.0.1.0/24)"
  validation {
    condition = alltrue([for range in var.ssh_access_source_ranges: can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(3[0-2]|[1-2][0-9]|[0-9]))$", range))])
    error_message = "One or more invalid IP ranges."
  }
}

variable "mx_password" {
  type = string
  description = "Enter a password for your Management Server's admin user"
  sensitive = true
  validation {
    condition = length(var.mx_password) >= 7
    error_message = "Password must be at least 7 characters long."
  }
}

variable "mx_zone" {
  type = string
  description = "Select the target zone for your MX instance"
}

variable "mx_instance_type" {
  type = string
  description = "Select the desired machine type for your Management-Server instance"
}

variable "mx_subnet_name" {
  type = string
  description = "Specify the subnet name for your Management-Server instance"
  validation {
    condition = can(regex("^[a-z].*", var.mx_subnet_name))
    error_message = "Must begin with a lowercase letter."
  }
}

variable "mx_termination_protection" {
  type = string
  description = "We recommand to keep this setting enabled to prevent MX resource destruction via terrafrom. This can be changed to false later in the tfvars file."
}

variable "gw_model" {
  type = string
  description = "Select the desired model for your Gateway servers"
}

variable "number_of_gateways" {
  type = number
  description = "Choose the number of Gateways to deploy"
}

variable "gw_zone" {
  type = string
  description = "Select the target zone for your Gateway instance(s)"
}

variable "gw_instance_type" {
  type = string
  description = "Select the desired machine type for your WAF Gateway instances"
}

variable "gw_subnet_name" {
  type = string
  description = "Specify the subnet name for your WAF Gateway instance(s)"
  validation {
    condition = can(regex("^[a-z].*", var.gw_subnet_name))
    error_message = "Must begin with a lowercase letter."
  }
}

locals {
  waf_image_url = "https://www.googleapis.com/compute/v1/projects/imperva-cloud-images-public/global/images/securesphere-waf-14-4-0-16-0-39028-europe"
  mx_tag = "${var.deployment_name}-mx"
  mx_fw_rules = {
    UI = {
      name = "${var.deployment_name}-mx-ui-access"
      direction = "INGRESS"
      source_ranges = var.ui_access_source_ranges
      source_tags = []
      target_tags = [
        local.mx_tag
      ]
      allow = [
        {
          protocol = "tcp"
          ports = [
            "8083"
          ]
        }
      ]
    }
    SSH = {
      name = "${var.deployment_name}-mx-ssh-access"
      direction = "INGRESS"
      source_ranges = var.ssh_access_source_ranges
      source_tags = []
      target_tags = [
        local.mx_tag
      ]
      allow = [
        {
          protocol = "tcp"
          ports = [
            "22"
          ]
        }
      ]
    }
    GW2MX = {
      name = "${var.deployment_name}-gw-to-mx-access"
      direction = "INGRESS"
      source_ranges = []
      source_tags = [
        local.gw_tag
      ]
      target_tags = [
        local.mx_tag
      ]
      allow = [
        {
          protocol = "tcp"
          ports = [
            "8083"
          ]
        }
      ]
    }
  }
  mx_secret_id = google_secret_manager_secret.mx_admin_secret.secret_id
  management_ip = google_compute_instance.mx_instance.network_interface[0].network_ip
  gw_tag = "${var.deployment_name}-gw"
  gw_fw_rules = {
    SSH = {
      name = "${var.deployment_name}-gw-ssh-access"
      direction = "INGRESS"
      source_ranges = var.ssh_access_source_ranges
      source_tags = []
      target_tags = [
        local.gw_tag
      ]
      allow = [
        {
          protocol = "tcp"
          ports = [
            "22"
          ]
        }
      ]
    }
    MX2GW = {
      name = "${var.deployment_name}-mx-to-gw-access"
      direction = "INGRESS"
      source_ranges = []
      source_tags = [
        local.mx_tag
      ]
      target_tags = [
        local.gw_tag
      ]
      allow = [
        {
          protocol = "tcp"
          ports = [
            "443"
          ]
        }
      ]
    }
  }
  gw_group = "gcp"
  gw_autoscaling = false
}

resource "google_service_account" "deployment_service_account" {
  account_id = "${var.deployment_name}-svc-acc"
}

resource "google_secret_manager_secret" "mx_admin_secret" {
  secret_id = "${var.deployment_name}-mx-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mx_admin_secret_version" {
  secret = google_secret_manager_secret.mx_admin_secret.id
  secret_data = var.mx_password
}

resource "google_secret_manager_secret_iam_member" "mx_admin_secret_iam_member" {
  secret_id = local.mx_secret_id
  role = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.deployment_service_account.email}"
}

resource "google_compute_instance" "mx_instance" {
  depends_on = [
    google_secret_manager_secret_version.mx_admin_secret_version
  ]
  name = "${var.deployment_name}-mx"
  description = "Imperva WAF Management Server (Deployment ID: ${var.deployment_name})"
  zone = var.mx_zone
  deletion_protection = var.mx_termination_protection
  tags = [
    local.mx_tag
  ]
  machine_type = var.mx_instance_type
  boot_disk {
    initialize_params {
      image = local.waf_image_url
    }
  }
  network_interface {
    subnetwork = var.mx_subnet_name
  }
  metadata = {
    startup-script = data.template_cloudinit_config.mx_gcp_deploy.rendered
    block-project-ssh-keys = var.block_project_ssh_keys
  }
  service_account {
    email = google_service_account.deployment_service_account.email
    scopes = [
      "cloud-platform"
    ]
  }
}

resource "time_sleep" "await_mx_ftl" {
  depends_on = [
    google_compute_instance.mx_instance
  ]
  create_duration = "20m"
}

resource "google_compute_firewall" "mx_firewall" {
  for_each = local.mx_fw_rules
  name = each.value.name
  network = var.vpc_network
  direction = each.value.direction
  source_ranges = each.value.source_ranges
  source_tags = each.value.source_tags
  target_tags = each.value.target_tags
  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports = allow.value.ports
    }
  }
}

resource "google_compute_firewall" "gw_firewall" {
  for_each = local.gw_fw_rules
  name = each.value.name
  network = var.vpc_network
  direction = each.value.direction
  source_ranges = each.value.source_ranges
  source_tags = each.value.source_tags
  target_tags = each.value.target_tags
  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports = allow.value.ports
    }
  }
}

resource "google_compute_instance" "gw_instance" {
  depends_on = [
    time_sleep.await_mx_ftl
  ]
  count = var.number_of_gateways
  name = format("${var.deployment_name}-gw-%d", count.index)
  description = "Imperva WAF Gateway (Deployment ID: ${var.deployment_name})"
  zone = var.gw_zone
  tags = [
    local.gw_tag
  ]
  machine_type = var.gw_instance_type
  boot_disk {
    initialize_params {
      image = local.waf_image_url
    }
  }
  network_interface {
    subnetwork = var.gw_subnet_name
  }
  metadata = {
    startup-script = data.template_cloudinit_config.gw_gcp_deploy.rendered
    block-project-ssh-keys = var.block_project_ssh_keys
  }
  service_account {
    email = google_service_account.deployment_service_account.email
    scopes = [
      "cloud-platform"
    ]
  }
}

resource "time_sleep" "await_gw_ftl" {
  depends_on = [
    google_compute_instance.gw_instance
  ]
  create_duration = "8m"
}

output "management_server_url" {
  value = "https://${google_compute_instance.mx_instance.network_interface[0].network_ip}:8083"
}

output "ftl_log_file" {
  value = "/var/log/gcp_gdm.log"
}