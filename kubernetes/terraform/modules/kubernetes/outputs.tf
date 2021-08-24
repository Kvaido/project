output "external_cluster_ip" {
  value = yandex_kubernetes_cluster.otus_cluster.master[0].public_ip
}
