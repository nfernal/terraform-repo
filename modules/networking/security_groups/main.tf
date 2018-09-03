resource "aws_security_group" "test_sg" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.sg_vpc_id}"
  ingress = "${var.sg_ingress}"
egress = "${var.sg_egress}"
}

