output "kubernetes_subnet" {
  value = yandex_vpc_subnet.kubernetes_subnet.id
}
output "kubernetes_network" {
  value = yandex_vpc_network.kubernetes_network.id
}
