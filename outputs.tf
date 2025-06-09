output "swarm_status" {
  description = "Docker Swarm status"
  value       = data.external.swarm_status.result
}

output "swarm_initialized" {
  description = "Swarm initialization status"
  value       = length(terraform_data.swarm_init) > 0 ? "initialized" : "active"
}