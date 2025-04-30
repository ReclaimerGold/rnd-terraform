variable "name_prefix" {
    type = string
}
variable "index" {
    type = number
}
variable "memory" {
    type = number
}
variable "balloon" {
    type = number
}
variable "cores" {
    type = number
}
variable "tags" {
    type = string
}
variable "pool" {
    type = string
}
variable "scsihw" {
    type = string
}
variable "disk_size" {
    type = string
}
variable "storage_pool" {
    type = string
}
variable "iso" {
    type = string
}
variable "bridge" {
    type = string
}
variable "vlan_tag" {
    type = number
}
variable "target_nodes" {
    type = list(string)
}
