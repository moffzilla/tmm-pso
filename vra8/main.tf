terraform {
  required_providers {
    vra = {
      source = "vmware/vra"
      version = "0.3.2"
    }
  }
}

provider vra {
  url           = var.vra_url
  refresh_token = var.vra_refresh_token
  insecure = true
}

resource "vra_cloud_account_aws" "this" {
  name        = "AWS Mofeta Cloud Account"
  description = "AWS Mofeta Cloud Account configured by Terraform"
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
  regions     = ["us-east-1", "us-west-1"]

  tags {
    key   = "cloud"
    value = "aws"
  }
}

data "vra_region" "this" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = "us-west-1"
}

# Configure a new Cloud Zone
resource "vra_zone" "this" {
  name        = "AWS US West Zone"
  description = "Cloud Zone configured by Terraform"
  region_id   = data.vra_region.this.id

  tags {
    key   = "cloud"
    value = "aws"
  }
}

# Create an flavor profile
resource "vra_flavor_profile" "this" {
  name        = "terraform-flavour-profile"
  description = "Flavour profile created by Terraform"
  region_id   = data.vra_region.this.id

  flavor_mapping {
    name          = "x-small"
    instance_type = "t2.micro"
  }

  flavor_mapping {
    name          = "small"
    instance_type = "t2.small"
  }

  flavor_mapping {
    name          = "medium"
    instance_type = "t2.medium"
  }
  
  flavor_mapping {
    name          = "large"
    instance_type = "t2.large"
  }
}

# Create a new image profile
resource "vra_image_profile" "this" {
  name        = "terraform-aws-image-profile"
  description = "AWS image profile created by Terraform"
  region_id   = data.vra_region.this.id

  image_mapping {
    name       = "ubuntu-bionic"
    image_name = "ami-0dd655843c87b6930"
  }
}

# Create a new Project
resource "vra_project" "this" {
  name        = "Mofeta Terraform Project"
  description = "Mofeta Project configured by Terraform"

  administrators = ["tony@coke.sqa-horizon.local"]
  members           = ["tony@coke.sqa-horizon.local"]

  zone_assignments {
    zone_id       = vra_zone.this.id
    priority      = 1
    max_instances = 0
  }
}

# Create a new Blueprint
resource "vra_blueprint" "this" {
  name        = "Ubuntu Blueprint"
  description = "Created by vRA terraform provider"
  project_id = vra_project.this.id

  content = <<-EOT
formatVersion: 1
inputs:
  Flavor:
    type: string
    title: Flavor
    enum:
      - x-small
      - large
      - medium
      - small
  Image:
    type: string
    title: Image 
    enum:
      - ubuntu-xenial
      - ubuntu-bionic
resources:
  Web_Server:
    type: Cloud.Machine
    properties:
      image: '$${input.Image}'
      flavor: '$${input.Flavor}'
      cloudConfig: |
        users:
          - name: sam
            ssh-authorized-keys:
              - 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAJhmOeILoSyY2ke8oQu1pJ8td12ReCFbc5ZQflXcxYoTcUp00CLKrvdQzrOnOJAUGR0QOjp/2LxvOgq0lR0g3qSOX9Cg+wTxpOKP/VQRw9+SWv625bbAk3R6VSzIG83XJ24MPwmsa9wPgaU4cCc9SmXzKJEQGtAd9QNyO2c5fxEynZUsZbbQiNtZbliA0lyU3dAnPOofdhJ6I6aV2YFvp4juy9NdaNuR7HUTwyUfMOvilcTzdsJ/dJrc9Ypl427vgZk4opmlikVBLlWvJdBLt8PgPpl4GWgkg+WBqPUu33ExB6MfWNvXUjC3u1D9sokJwQw4NBXvvQHg4Dpf+IP75'
            sudo:
              - 'ALL=(ALL) NOPASSWD:ALL'
            groups: sudo
            shell: /bin/bash
      constraints:
        - tag: 'cloud:aws'
  EOT
}

output "blueprint-ID" {
  description = "Cloud Template ID"
  value       = vra_blueprint.this.id
}

output "blueprint-name" {
  description = "Cloud Template ID"
  value       = vra_blueprint.this.name
}


output "Project-ID" {
  description = "Project ID"
  value       = vra_blueprint.this.project_id
}


