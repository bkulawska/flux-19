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
