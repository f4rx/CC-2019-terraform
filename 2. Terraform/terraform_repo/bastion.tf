###################################
# Create port
###################################
resource "openstack_networking_port_v2" "bastion_port" {
  name       = "bastion-eth0"
  network_id = "${openstack_networking_network_v2.network_1.id}"

  fixed_ip {
    subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
  }
}

###################################
# Create Volume/Disk
###################################
resource "openstack_blockstorage_volume_v3" "volume_bastion" {
  name                 = "volume-for-bastion-server"
  size                 = "${var.hdd_size}"
  image_id             = "${data.openstack_images_image_v2.image_bastion.id}"
  volume_type          = "${var.volume_type}"
  availability_zone    = "${var.az_zone}"
  enable_online_resize = true

  lifecycle {
    ignore_changes = ["image_id"]
  }
}

###################################
# Create Server
###################################
resource "openstack_compute_instance_v2" "bastion" {
  name              = "bastion"
  flavor_id         = "${data.openstack_compute_flavor_v2.flavor_1.id}"
  key_pair          = "${openstack_compute_keypair_v2.terraform_key.id}"
  availability_zone = "${var.az_zone}"

  network {
    port = "${openstack_networking_port_v2.bastion_port.id}"
  }

  block_device {
    uuid             = "${openstack_blockstorage_volume_v3.volume_bastion.id}"
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

  vendor_options {
    ignore_resize_confirmation = true
  }

  provisioner "file" {
    source      = "files/bootstrap"
    destination = "/tmp/"
    connection {
      type = "ssh"
      host = "${openstack_networking_floatingip_v2.floatingip_bastion.address}"
      user = "root"
      # Если испольщуется ssh-agent
      agent = true
      # Если ssh-agent не используется, то закоментировать строку выше, и раскоментировать тут
      #private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "file" {
    content     = "${local.grafana_config}"
    destination = "/root/grafana.ini"

    connection {
      type = "ssh"
      host = "${openstack_networking_floatingip_v2.floatingip_bastion.address}"
      user = "root"
      # Если испольщуется ssh-agent
      agent = true
      # Если ssh-agent не используется, то закоментировать строку выше, и раскоментировать тут
      #private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap/bootstrap.sh",
      "/tmp/bootstrap/bootstrap.sh",
      "rm -rf /tmp/bootstrap"
    ]

    connection {
      type = "ssh"
      host = "${openstack_networking_floatingip_v2.floatingip_bastion.address}"
      user = "root"
      # Если испольщуется ssh-agent
      agent = true
      # Если ssh-agent не используется, то закоментировать строку выше, и раскоментировать тут
      #private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

locals {
  grafana_config = templatefile("templates/grafana.ini.tpl",
    {
      password : "${var.grafana_password}"
    },
  )
}

resource "openstack_networking_floatingip_v2" "floatingip_bastion" {
  pool = "external-network"
}

resource "openstack_networking_floatingip_associate_v2" "association_bastion" {
  port_id     = "${openstack_networking_port_v2.bastion_port.id}"
  floating_ip = "${openstack_networking_floatingip_v2.floatingip_bastion.address}"
}
