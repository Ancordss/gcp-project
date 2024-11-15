output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "kubeconfig_done" {
  value = null_resource.get_kubeconfig.id
}