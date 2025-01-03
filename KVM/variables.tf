variable "f5xc-ce-qcow2" {
    description = "KVM CE QCOW2 image source"
    default = "/home/veysph/f5xc-ce-9.2024.40-20241127112749.qcow2"
}

variable "f5xc-ce-memory" {
    description = "Memory allocated to KVM CE"
    default = "16384"
}

variable "f5xc-ce-vcpu" {
    description = "Number of vCPUs allocated to KVM CE"
    default = "4"
}

variable "f5xc-ce-site-name" {
    description = "KVM CE site/cluster name"
    default = "pv-smsv2-kvm"
}

variable "f5xc-ce-node-name" {
    description = "KVM CE node name"
    default = "node-0"
}

variable "f5xc-ce-storage-pool" {
    description = "KVM CE storage pool name"
    default = "veysph"
}

variable "f5xc-ce-network" {
    description = "KVM CE storage pool name"
    default = "kvmnet"
}