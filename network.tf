resource "google_compute_network" "vpc_network" {
  name                            = var.name
  project                         = var.project
  description                     = var.description
  auto_create_subnetworks         = var.auto_create_subnetworks
  delete_default_routes_on_create = var.delete_default_routes_on_create
  routing_mode                    = var.routing_mode

}

resource "google_compute_firewall" "vpc_firewall_allow" {
  count                   = length(var.allow_rules)
  name                    = "${var.name}-${replace(var.allow_rules[count.index].name, "_", "-")}-allow"
  network                 = google_compute_network.vpc_network.name
  source_tags             = var.allow_rules[count.index].name == "source_tags" ? var.allow_rules[count.index].list : []
  source_ranges           = var.allow_rules[count.index].name == "source_ranges" ? var.allow_rules[count.index].list : []
  source_service_accounts = var.allow_rules[count.index].name == "source_service_accounts" ? var.allow_rules[count.index].list : []
  target_tags             = var.allow_rules[count.index].name == "target_tags" ? var.allow_rules[count.index].list : []
  target_service_accounts = var.allow_rules[count.index].name == "target_service_accounts" ? var.allow_rules[count.index].list : []
  dynamic "allow" {
    for_each = [for rule in var.allow_rules[count.index].rules: {
      protocol = lookup(rule, "protocol", null)
      ports    = lookup(rule, "ports", null)
    }]
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}

resource "google_compute_firewall" "vpc_firewall_deny" {
  count                   = length(var.deny_rules)
  name                    = "${var.name}-${replace(var.deny_rules[count.index].name, "_", "-")}-deny"
  network                 = google_compute_network.vpc_network.name
  source_tags             = var.deny_rules[count.index].name == "source_tags" ? var.deny_rules[count.index].list : []
  source_ranges           = var.deny_rules[count.index].name == "source_ranges" ? var.deny_rules[count.index].list : []
  source_service_accounts = var.deny_rules[count.index].name == "source_service_accounts" ? var.deny_rules[count.index].list : []
  target_tags             = var.deny_rules[count.index].name == "target_tags" ? var.deny_rules[count.index].list : []
  target_service_accounts = var.deny_rules[count.index].name == "target_service_accounts" ? var.deny_rules[count.index].list : []
  dynamic "deny" {
    for_each = [for rule in var.deny_rules[count.index].rules: {
      protocol = lookup(rule, "protocol", null)
      ports    = lookup(rule, "ports", null)
    }]
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}
