terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.88"
    }
  }
}
provider "yandex" {
  token     = "t1.9euelZqdyMiNl82WyY2UkIyZnpnHi-3rnpWalpbKmYnLypfImc-SlZCOy8rl8_cqMGFK-e8IA0kH_d3z92peXkr57wgDSQf9zef1656Vms6Pj5XGx4nKmpiOip2eyZHP7_zN5_XrnpWazIzKyZeaksaYjZialpyeiZXv_cXrnpWazo-PlcbHicqamI6KnZ7Jkc8.zho5GfdtNUCOUL6N2QcOGqO0N6CSzNGIRFJuOsxEoKmL_MwP5aBoUiJLRi7HyMdVDeVFf1xqXfXFFmpmYzuwDw"
  cloud_id  = "aje3s56hem9grgeicavj"
  folder_id = "b1ge0llpg1gnn3hpv1n4"
  zone      = "ru-central1-a"
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

  
