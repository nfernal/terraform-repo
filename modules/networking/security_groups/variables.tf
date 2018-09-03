variable "sg_name" {
  type = "string"
  description = "Security group name"
}

variable "sg_description" {
  type = "string"
  description = "Description of security group"
}

variable "sg_ingress" {
  type = "list"
  description = "List of security group ingress rules"
  default = [
  { from_port = 22 to_port = 22 protocol = "TCP" cidr_blocks = ["0.0.0.0/0"]} ]
}

variable "sg_egress" {
  type = "list"
  description = "describe your variable"
  default = [
   { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"]}
   ]
}

variable "sg_vpc_id" {
  type = "string"
  description = "ID of the VPC where the SG will be used"
}
