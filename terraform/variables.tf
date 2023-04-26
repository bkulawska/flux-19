variable "region" {
    type = string
    default = "us-east-1"
}

variable "proj_name" {
    type = string
    default = "suu-flux"
}

variable "node_azs" {
  description = "availability zones belonging to the given region where nodes should be run"
  type = list
  default = ["a", "b", "c"]
}

variable "lab_role_arn" {
    description = "important: lab account doesn't allow us to perform GetRole action on aws and we need to get this arn manually. To do this go to aws IAM -> Roles -> find LabRole -> copy its arn"
    type=string
}
