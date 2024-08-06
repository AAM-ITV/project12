# Укажите провайдер
provider "yandex" {
  service_account_key_file = "AQVN2bRnQ6dBa5hvYtf_8475j4CvS8tETIcYkzfd"
  cloud_id                 = "b1gpl53sdobvpahkcboc"
  folder_id                = "b1ge0llpg1gnn3hpv1n4"
}

# Определите переменные
variable "service_account_key_file" {
  description = "Path to the service account key file"
  default     = "AQVN2bRnQ6dBa5hvYtf_8475j4CvS8tETIcYkzfd"
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  default     = "b1gpl53sdobvpahkcboc"
}

variable "folder_id" {
  description = "Yandex Folder ID"
  default     = "b1ge0llpg1gnn3hpv1n4"
}

variable "subnet_id" {
  description = "Subnet ID for the instances"
  default     = "ru-central1-d"
}

# Определите ресурсы
resource "yandex_compute_instance" "build_node" {
  name        = "build-node"
  platform_id = "standard-v1"
  resources {
    cores  = 4
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = "fd8k20lhm9jl4sbjjv4g"
    }
  }
  network_interface {
    subnet_id = var.subnet_id
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
    cores  = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8k20lhm9jl4sbjjv4g"
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  metadata = {
    ssh-keys = "user:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Определите выходные данные
output "build_node_ip" {
  value = yandex_compute_instance.build_node.network_interface.0.ip_address
}

output "prod_node_ip" {
  value = yandex_compute_instance.prod_node.network_interface.0.ip_address
}
