terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id  = "b1go70qkg5aqrl1gbc1t"
  folder_id = "b1gh99qee3dqi4r48nb0"
  zone      = "ru-central1-a"
}

resource "yandex_compute_image" "ubuntu-image" {
  name       = "my-ubuntu-image"
  source_image = "fd8f1tik9a7ap9ik2dg1"
}

resource "yandex_compute_instance" "vm-1" {
  name = "tf-atlantis"
  description = "First test instance"
  hostname = "vm1"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.ubuntu-image.id}"
      name        = "root-vm-1"
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = "e9b17r3b387ge21o7rd2"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
  }

}
