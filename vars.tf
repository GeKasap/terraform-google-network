variable "name" {
  type = string
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "description" {
  type = string
  description = "An optional description for the network"
  default = ""
}

variable "ipv4_range" {
  type = string
  description = "(Optional, Deprecated) If this field is specified, a deprecated legacy network is created. You will no longer be able to create a legacy network on Feb 1, 2020. See the legacy network docs for more details. The range of internal addresses that are legal on this legacy network. This range is a CIDR specification, for example: 192.168.0.0/16. The resource must be recreated to modify this field."
  default = ""
}

variable "allow_rules" {
  type = list(object({
    name = string
    list = list(string)
    rules = list(object({
      protocol = string
      ports = list(string)
    }))
  }))
  description = "A list of rules and tcp/udp ports to be allowed. Valid names are "
  default = []
}

variable "deny_rules" {
  type = list(object({
    name = string
    list = list(string)
    rules = list(object({
      protocol = string
      ports = list(string)
    }))
  }))
  description = "A list of rules and tcp/udp ports to be denied. Valid names are "
  default = []
}

variable "auto_create_subnetworks" {
  type = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default = true
}

variable "routing_mode" {
  type = string
  description = "The network-wide routing mode to use. If set to REGIONAL, this network's cloud routers will only advertise routes with subnetworks of this network in the same region as the router. If set to GLOBAL, this network's cloud routers will advertise routes with all subnetworks of this network, across regions."
  default = "REGIONAL"
}

variable "project" {
  type = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "delete_default_routes_on_create" {
  type = bool
  description = "If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false."
  default = false
}