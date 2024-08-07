terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.88"
    }
  }
  required_version = ">= 1.7.0"
}
provider "yandex" {
  token     = "y0_AgAAAAAGKyuaAATuwQAAAAEL6APzAABFyWvjhZVO46RIP6-7enyK-JzXvg"
  cloud_id  = "b1gpl53sdobvpahkcboc"
  folder_id = "b1ge0llpg1gnn3hpv1n4"
  zone      = "ru-central1-d"
}
resource "yandex_compute_instance" "build_node" {
  name        = "build-node"
  platform_id = "standard-v3"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 30
      type     = "network-ssd"
    }
  }
  network_interface {
    subnet_id = "fl8h2bv6lfj7hqei7bf5"
    nat       = true
  }

metadata = {
  ssh-keys = "user:${file("/home/user/id_ed25519.pub")}"
 }
}

resource "yandex_compute_instance" "prod_node" {
  name        = "prod-node"
  platform_id = "standard-v3"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd88m3uah9t47loeseir"
      size     = 30
      type     = "network-ssd"
    }
  }
  network_interface {
    subnet_id = "fl8h2bv6lfj7hqei7bf5"
    nat       = true
  }
metadata = {
  ssh-keys = "root:${file("/home/user/id_ed25519.pub")}"
 }
}
output "build_node_ip" {
  value = yandex_compute_instance.build_node.network_interface.0.nat_ip_address
}

output "prod_node_ip" {
  value = yandex_compute_instance.prod_node.network_interface.0.nat_ip_address
}
