data "template_file" "f5xc-ce-user_data" {
  template = file("${path.module}/user-data")
}

# data "template_file" "f5xc-ce-meta_data" {
#   template = file("${path.module}/meta-data")
# }

resource "libvirt_volume" "f5xc-ce-volume" {
  name   = "${var.f5xc-ce-site-name}-${var.f5xc-ce-node-name}.qcow2"
  pool   = var.f5xc-ce-storage-pool
  source = var.f5xc-ce-qcow2
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "f5xc-ce-cloudinit" {
  name      = "${var.f5xc-ce-site-name}-${var.f5xc-ce-node-name}-cloud-init.iso"
  pool      = var.f5xc-ce-storage-pool
  user_data = data.template_file.f5xc-ce-user_data.rendered
  # meta_data = data.template_file.kvm-ce-meta_data.rendered
}

resource "libvirt_domain" "kvm-ce" {
  name   = "${var.f5xc-ce-site-name}-${var.f5xc-ce-node-name}"
  memory = var.f5xc-ce-memory
  vcpu   = var.f5xc-ce-vcpu

  disk {
    volume_id = libvirt_volume.f5xc-ce-volume.id
  }

  cloudinit = libvirt_cloudinit_disk.f5xc-ce-cloudinit.id

  cpu {
    mode = "host-passthrough"
  }
 
  network_interface {
    network_name = var.f5xc-ce-network
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}