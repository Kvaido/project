provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "vpc" {
  source = "../modules/vpc"
}

module "kubernetes" {
  source                 = "../modules/kubernetes"
  network_id             = module.vpc.kubernetes_network
  service_account_key_id = var.service_account_key_id
  subnet_id              = module.vpc.kubernetes_subnet
}
