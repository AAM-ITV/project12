resource "yandex_compute_disk" "boot-disk" {
  name     = "SSD"
  type     = "network-ssd"
  zone     = "ru-central1-d"
  size     = "30"
  image_id = "fd8mblds2nfkjcrrh3e7"
}

resource "yandex_compute_instance" "build_node" {
  name                      = "linux-vm"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "<зона_доступности>"

  resources {
    cores  = "<количество_ядер_vCPU>"
    memory = "<объем_RAM_ГБ>"
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "<имя_пользователя>:<содержимое_SSH-ключа>"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "<зона_доступности>"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}



//////////////////////////////////////////////////////////////////////////

provider "yandex" {
  token     = "y0_AgAAAAAGKyuaAATuwQAAAAEL6APzAABFyWvjhZVO46RIP6-7enyK-JzXvg"
  cloud_id  = "b1gpl53sdobvpahkcboc"
  folder_id = "b1ge0llpg1gnn3hpv1n4"
  zone      = "ru-central1-d"
}

resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_security_group" "default" {
  name      = "default"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = "22"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = "80"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = "443"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_nat_gateway" "nat" {
  name     = "my-nat-gateway"
  network_id = yandex_vpc_network.network-1.id
  zone     = "ru-central1-d"
}

resource "yandex_vpc_route_table" "route_table" {
  name     = "my-route-table"
  network_id = yandex_vpc_network.network-1.id

  route {
    destination = "0.0.0.0/0"
    gateway_id   = yandex_vpc_nat_gateway.nat.id
  }
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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.default.id]
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
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.default.id]
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

output "build_node_ip" {
  value = yandex_compute_instance.build_node.network_interface.0.nat_ip_address
}

output "prod_node_ip" {
  value = yandex_compute_instance.prod_node.network_interface.0.nat_ip_address
}
