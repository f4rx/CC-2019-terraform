module "nodes" {
  source = "./modules/create_server"

  server_count = "${var.server_count}"

  network_id = "${openstack_networking_network_v2.network_1.id}"
  subnet_id  = "${openstack_networking_subnet_v2.subnet_1.id}"

  image_id    = "${data.openstack_images_image_v2.image_node.id}"
  region      = "${var.region}"
  az_zone     = "${var.az_zone}"
  volume_type = "${var.volume_type}"

  key_pair_id = "${openstack_compute_keypair_v2.terraform_key.id}"
  flavor_id   = "${data.openstack_compute_flavor_v2.flavor_1.id}"
}
