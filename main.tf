terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.88"
    }
  }
}
provider "yandex" {
  token     = "AQVN3tmenATF2otok5iUzN88Dr9fFajUKgL-XZRX"
  cloud_id  = "b1gpl53sdobvpahkcboc"
  folder_id = "b1ge0llpg1gnn3hpv1n4"
  zone      = "ru-central1-d"
}
resource "yandex_compute_instance" "build_node" {
  name        = "build-node"
  platform_id = "standard-v1"
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
    subnet_id = "e9bbqtbbo4evg3kk5esc"
    nat       = true
  }

  metadata = {
    ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "prod_node" {
  name        = "prod-node"
  platform_id = "standard-v1"
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
    subnet_id = "e9bbqtbbo4evg3kk5esc"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }  
 }

  
