locals {
  stack_name = var.stack_name

  stack_replicas_env = join(" ", [
    for service_replicas_env, replica_count in var.replicas :
    "${service_replicas_env}=${replica_count}"
  ])

}

# Create Docker Stack Secrets
resource "terraform_data" "docker_secrets" {
  for_each = nonsensitive(var.secrets)

  input = {
    secret_name  = each.value.name
    secret_value = var.secrets[each.key].value
  }

  provisioner "local-exec" {
    command     = "echo '${self.input.secret_value}' | docker secret create ${self.input.secret_name} - || true"
    working_dir = path.cwd
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "docker stack rm ${self.input.secret_name} || true"
    working_dir = path.cwd
  }
}

# Deploy Docker Stack
resource "terraform_data" "deploy_stack" {
  input = {
    stack_name   = local.stack_name
    compose_file = var.compose_file
    replicas = var.replicas
  }

  provisioner "local-exec" {
    command     = "${local.stack_replicas_env} docker stack deploy --resolve-image changed -c ${self.input.compose_file} ${self.input.stack_name}"
    working_dir = path.cwd
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "docker stack rm ${self.input.stack_name} || true"
    working_dir = path.cwd
  }
}

# Handle replica changes
resource "null_resource" "stack_replicas_update" {
  triggers = {
    replicas = jsonencode(var.replicas)
  }

  depends_on = [terraform_data.deploy_stack]

  provisioner "local-exec" {
    command     = "${local.stack_replicas_env} docker stack deploy --resolve-image changed -c ${var.compose_file} ${var.stack_name}"
    working_dir = path.cwd
  }
}

