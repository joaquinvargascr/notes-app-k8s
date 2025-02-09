terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

resource "random_string" "random_name" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "ns-${random_string.random_name.result}"
  }
}

resource "kubernetes_deployment" "notes-deployment" {

}
