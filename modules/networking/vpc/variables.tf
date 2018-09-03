variable "region" {
  type = "string"
  description = "AWS Region"
  default = "us-west-2"
}

variable "vpc_name" {
  type        = "string"
  description = "Name of the VPC to create"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "VPC CIDR block with slash notation subnet mask"
  // EXAMPLE: 10.0.0.0/16
}

variable "vpc_instance_tenancy" {
  type        = "string"
  description = "Option for VPC ec2 instance tenancy"
  default     = "default"

  // default, dedicated, host
}

variable "vpc_enable_dns_support" {
  type        = "string"
  description = "Enable DNS support in VPC"
  default     = "true"
}

variable "vpc_enable_dns_hostnames" {
  type        = "string"
  description = "Enable DNS hostname resolution"
  default     = "true"
}
