# Check if swarm is active
data "external" "swarm_status" {
  program = [
    "bash", "-c",
    "STATUS=$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null || echo 'inactive'); echo \"{\\\"status\\\":\\\"$STATUS\\\"}\""
  ]
}

data "external" "mongo_keyfile" {
  program = ["bash", "-c", "echo '{\"value\": \"'$(openssl rand -base64 756)'\"}'"]
}

locals {
  active_stacks = tomap({
    for stack_name, services in var.stack_service_replicas_env_config : stack_name => (
      length([
        for service_name, replicas in services : service_name
        if replicas > 0
      ]) > 0 ? 1 : 0
    )
  })

  mongo_keyfile     = var.mongo_keyfile != null ? var.mongo_keyfile : data.external.mongo_keyfile.result.value
  mongo_username    = var.mongo_username != null ? var.mongo_username : "mongo"
  mongo_password    = var.mongo_password != null ? var.mongo_password : "mongo"
  postgres_user     = var.postgres_user != null ? var.postgres_user : "postgres"
  postgres_password = var.postgres_password != null ? var.postgres_password : "postgres"
}

# Initialize swarm
resource "terraform_data" "swarm_init" {
  count = contains(["inactive", ""], data.external.swarm_status.result) ? 1 : 0

  provisioner "local-exec" {
    command = "docker swarm init --task-history-limit=0"
  }
}

# Wait for swarm to be ready
resource "terraform_data" "swarm_ready" {
  depends_on = [terraform_data.swarm_init]

  provisioner "local-exec" {
    command = "sleep 3"
  }
}

# Deploy Proxy Stack
module "proxy_stack" {
  source = "./modules/docker-swarm-stack"
  depends_on = [terraform_data.swarm_ready]

  stack_name   = "proxy"
  compose_file = "proxy-stack.yml"
}

# Deploy Management Stack
module "management_stack" {
  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "management"
  compose_file = "management-stack.yml"
}

# Deploy DB Stack
module "db_stack" {
  count = local.active_stacks["db"]

  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "db"
  compose_file = "db-stack.yml"
  replicas = var.stack_service_replicas_env_config.db

  secrets = {
    mongo-keyfile = {
      name  = "mongo-keyfile"
      value = local.mongo_keyfile
    }
    mongo-username = {
      name  = "mongo-username"
      value = local.mongo_username
    }
    mongo-password = {
      name  = "mongo-password"
      value = local.mongo_password
    }
    postgres-user = {
      name  = "postgres-user"
      value = local.postgres_user
    }
    postgres-password = {
      name  = "postgres-password"
      value = local.postgres_password
    }
  }
}

# Deploy Auth Stack
module "auth_stack" {
  count = local.active_stacks["auth"]

  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "auth"
  compose_file = "auth-stack.yml"
  replicas = var.stack_service_replicas_env_config.auth
}

# Deploy Event Streaming Stack
module "event_streaming_stack" {
  count = local.active_stacks["event-streaming"]

  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "event-streaming"
  compose_file = "event-streaming-stack.yml"
  replicas = var.stack_service_replicas_env_config.event-streaming
}

# Deploy SMTP Stack
module "smtp_stack" {
  count = local.active_stacks["smtp"]

  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "smtp"
  compose_file = "smtp-stack.yml"
  replicas = var.stack_service_replicas_env_config.smtp
}

# Deploy Git Stack
module "automation_stack" {
  count = local.active_stacks["automation"]

  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "automation"
  compose_file = "automation-stack.yml"
  replicas = var.stack_service_replicas_env_config.automation
}

# Deploy Git Stack
module "git_stack" {
  count = local.active_stacks["git"]

  source = "./modules/docker-swarm-stack"
  depends_on = [module.proxy_stack]

  stack_name   = "git"
  compose_file = "git-stack.yml"
  replicas = var.stack_service_replicas_env_config.git
}