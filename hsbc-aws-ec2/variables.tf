variable "aws_region" {
  description = "AWS region"
}

variable "key_name" {
  type = "string"
  description = "describe your variable"
}

variable "public_key_path" {
  type = "string"
  description = "describe your variable"
}

variable "instance_type" {
  type = "string"
  description = "describe your variable"
}

variable "ssh_cidr_blocks" {
  type = "list"
  description = "describe your variable"
}

variable "ssl_cidr_blocks" {
  type = "list"
  description = "describe your variable"
}

variable "http_cidr_blocks" {
  type = "list"
  description = "describe your variable"
}

variable "https_cidr_blocks" {
  type = "list"
  description = "describe your variable"
}