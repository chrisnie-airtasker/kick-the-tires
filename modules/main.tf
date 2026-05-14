variable "project_name" {
  type        = string
  description = "Project identifier used in resource logs and triggers"
}

variable "resource_count" {
  type        = number
  default     = 1
  description = "Number of simulated resources to create"
}

resource "null_resource" "this" {
  count = var.resource_count

  triggers = {
    project        = var.project_name
    workspace      = terraform.workspace
    resource_index = count.index
  }

  provisioner "local-exec" {
    command = "echo '[${var.project_name}/${terraform.workspace}] resource-${count.index}'"
  }
}

output "resource_ids" {
  description = "IDs of the simulated resources"
  value       = null_resource.this[*].id
}
