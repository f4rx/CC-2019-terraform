output "bastion_floatingip_address" {
  value = "${openstack_networking_floatingip_v2.floatingip_bastion.address}"
}
output "prometheus_dashboard" {
  value = "http://${openstack_networking_floatingip_v2.floatingip_bastion.address}:9090/targets"
}
output "grafana_dashboard" {
  value = "http://${openstack_networking_floatingip_v2.floatingip_bastion.address}:3000/ with login admin and password ${var.grafana_password}"
}
output "LB_floatingip_address" {
  value = "${openstack_networking_floatingip_v2.floatingip_lb.address}"
}
output "site_address" {
  value = "http://${openstack_networking_floatingip_v2.floatingip_lb.address}"
}
