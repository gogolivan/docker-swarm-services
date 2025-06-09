output "stack_deployed" {
  description = "Docker stack deployment status"
  value       = terraform_data.deploy_stack.id
}

output "stack_name" {
  description = "Deployed stack name"
  value       = var.stack_name
}

output "replicas" {
  description = "Deployed stack replicas"
  value = var.replicas
}
