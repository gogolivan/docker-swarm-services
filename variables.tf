variable "stack_service_replicas_env_config" {
  description = <<-EOT
    Defines the number of replicas for each service within their respective stacks, and
    configures environment variables that are passed to Docker Compose files for dynamic scaling.
  EOT

  type = object({
    db = map(number)
    auth = map(number)
    event-streaming = map(number)
    smtp = map(number)
    automation = map(number)
    git = map(number)
  })
  default = {
    db = {
      MONGO1_REPLICAS     = 1
      MONGO2_REPLICAS     = 0
      MONGO3_REPLICAS     = 0
      MONGO_INIT_REPLICAS = 0
      POSTGRES_REPLICAS   = 0
      REDIS_REPLICAS      = 0
    }
    auth = {
      KEYCLOAK_REPLICAS = 1
    }
    event-streaming = {
      KAFKA_REPLICAS = 0
    },
    smtp = {
      MAILDEV_REPLICAS = 1
    }
    automation = {
      N8N_REPLICAS = 0
    }
    git = {
      GITEA_REPLICAS = 0
    }
  }
}

variable "mongo_keyfile" {
  type        = string
  default     = null
  sensitive   = true
  description = "MongoDB keyfile"
}

variable "mongo_username" {
  type        = string
  default     = ""
  description = "MongoDB username"
}

variable "mongo_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "MongoDB password"
}

variable "postgres_user" {
  type        = string
  default     = ""
  description = "PostgreSQL user"
}

variable "postgres_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "PostgreSQL password"
}