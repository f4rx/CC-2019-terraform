output "nodes_list" {
  value = "${openstack_compute_instance_v2.node}"
}
output "port_list" {
  value = "${openstack_networking_port_v2.port}"
}

output "node_ip_list" {
  value = "${openstack_networking_port_v2.port.*.all_fixed_ips.0}"
}


