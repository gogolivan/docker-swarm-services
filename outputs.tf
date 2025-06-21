output "swarm_status" {
  description = "Docker Swarm status"
  value       = data.external.swarm_status.result
}

output "swarm_initialized" {
  description = "Swarm initialization status"
  value       = length(terraform_data.swarm_init) > 0 ? "initialized" : "active"
}

output "traefik_stack" {
  description = "Traefik stack module output"
  value       = module.traefik_stack
}

output "nginx_stack" {
  description = "NGINX stack module output"
  value       = module.nginx_stack
}

output "portainer_stack" {
  description = "Portainer stack module output"
  value       = module.portainer_stack
}

output "mongo_stack" {
  description = "Mongo stack module output"
  value       = module.mongo_stack
}

output "postgres_stack" {
  description = "Postgres stack module output"
  value       = module.postgres_stack
}

output "keycloak_stack" {
  description = "Keycloak stack module output"
  value       = module.keycloak_stack
}

output "kafka_stack" {
  description = "Kafka stack module output"
  value       = module.kafka_stack
}

output "maildev_stack" {
  description = "Maildev stack module output"
  value       = module.maildev_stack
}

output "n8n_stack" {
  description = "n8n stack module output"
  value       = module.n8n_stack
}

output "temporal_stack" {
  description = "Temporal stack module output"
  value       = module.temporal_stack
}

output "localstack_stack" {
  description = "Localstack stack module output"
  value       = module.localstack_stack
}

output "prometheus_stack" {
  description = "Prometheus stack module output"
  value = module.prometheus_stack
}

output "grafana_stack" {
  description = "Grafana stack module output"
  value = module.grafana_stack
}