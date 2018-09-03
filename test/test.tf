module "aws_vpc" {
  source                   = "../modules/networking/vpc"
  vpc_name                 = "mytestvpc"
  vpc_cidr_block           = "10.0.0.0/16"
  vpc_instance_tenancy     = "default"
  vpc_enable_dns_support   = "true"
  vpc_enable_dns_hostnames = "true"
}


module "aws_security_groups" {
  source = "../modules/networking/security_groups"
  sg_name = "test_sg"
  sg_description = "This is where you write a description"
  sg_vpc_id = "${module.aws_vpc.output_vpc_id}"
  sg_ingress = [
  { from_port = 22 to_port = 22 protocol = "TCP" cidr_blocks = ["0.0.0.0/0"]},
  { from_port = 80 to_port = 80 protocol = "TCP" cidr_blocks = ["0.0.0.0/0"]}
  ]
}
