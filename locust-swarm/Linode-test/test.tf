# Configure the Linode provider
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.16.0"
    }
  }
}


provider "linode" {
  token = var.token
}

# Define variables (replace with your actual values)
variable "token" {
  description = "Your Linode API Personal Access Token. (required)"
}


variable "linode_type" {
  type = string
  default = "g6-standard-1"
}

#variable "label" {
  #type = string
  #default = "my-linode"
#}

variable "image" {
  type = string
  default = "private/21445145"
}

variable "root_pass" {
  description = "Your password. (required)"
}

variable "region" {
  type = string
  default = "us-east"
}

variable "storage_account_names" {
  type    = list(string)
  default = ["var1", "var2", "var3"]
}

locals {
  locations = ["us-east", "eu-west", "ap-southeast"]
}


# Create multiple Linodes using count
resource "linode_instance" "terraform-web" {

  for_each = { for location in local.locations : location => {} }
  label           = format("terraform-web-%s", each.key)
  type      = var.linode_type
  image     = var.image
  root_pass = var.root_pass
  #region    = var.region
  region         = each.key 


  # Add additional configuration options here as needed
  # ...
}



