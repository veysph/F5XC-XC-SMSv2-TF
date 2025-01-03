terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = ">=0.7.6"
    }
  }
}

terraform {
  required_version = ">= 1.6.6"
}

provider "libvirt" {
  uri = "qemu:///system"
}