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

resource "linode_instance" "terraform-web" {
        image = "private/21613716"
        label = "Terraform-Web-Example"
       
        region = "us-east"
        type = "g6-standard-1"
}