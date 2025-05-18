variable "cluster_name" {
  default = "eks-academy"
}

variable "region" {
  default = "us-east-1"
}

variable "lab_role_arn" {
  description = "ARN da role LabRole fornecida pela conta AWS Academy"
  type        = string
}
