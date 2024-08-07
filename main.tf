terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.88"
    }
  }
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
    ssh-keys = "jenkins:${file("/var/lib/jenkins/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: jenkins
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file("/var/lib/jenkins/.ssh/id_rsa.pub")}
      EOF
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
    ssh-keys = "jenkins:${file("/var/lib/jenkins/.ssh/id_rsa.pub")}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: jenkins
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file("/var/lib/jenkins/.ssh/id_rsa.pub")}
      EOF
 }
}
