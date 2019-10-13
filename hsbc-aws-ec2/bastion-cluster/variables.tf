variable "aws_region" {
  description       = "AWS region"
}

variable "key_name" {
  type              = "string"
  description       = "describe your variable"
}

variable "public_key_path" {
  type              = "string"
  description       = "describe your variable"
}

variable "private_key_path" {
  type              = "string"
  description       = "describe your variable"
}

variable "instance_type" {
  type              = "string"
  description       = "describe your variable"
}

variable "min_size" {
  type              = "string"
  description       = "describe your variable"
  default           = 1
}

variable "max_size" {
  type              = "string"
  description       = "describe your variable"
  default           = 1
}