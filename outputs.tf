output "swarm_status" {
  description = "Docker Swarm status"
  value       = data.external.swarm_status.result
}

output "swarm_initialized" {
  description = "Swarm initialization status"
  value       = length(terraform_data.swarm_init) > 0 ? "initialized" : "active"
}

output "proxy_stack" {
  description = "Proxy stack module output"
  value = module.proxy_stack
}

output "management_stack" {
  description = "Management stack module output"
  value = module.management_stack
}

output "db_stack" {
  description = "DB stack module output"
  value = module.db_stack
}

output "auth_stack" {
  description = "Auth stack module output"
  value = module.db_stack
}

output "event_streaming_stack" {
  description = "Event Streaming stack module output"
  value = module.event_streaming_stack
}

output "smtp_stack" {
  description = "SMTP stack module output"
  value = module.smtp_stack
}

output "automation_stack" {
  description = "Automation stack module output"
  value = module.automation_stack
}

output "git_stack" {
  description = "Git stack module output"
  value = module.git_stack
}