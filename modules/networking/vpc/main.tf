## Creating VPC
resource "aws_vpc" "core_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "${var.vpc_instance_tenancy}"
  enable_dns_support   = "${var.vpc_enable_dns_support}"
  enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"

  tags {
    Name               = "${var.vpc_name}"
    CIDR               = "${var.vpc_cidr_block}"
    InstanceTenancy    = "${var.vpc_instance_tenancy}"
    EnableDNSSupport   = "${var.vpc_enable_dns_support}"
    EnableDNSHostnames = "${var.vpc_enable_dns_hostnames}"
  }
}

## Creating Public subnet it AZ A
resource "aws_subnet" "core_pub1" {
  vpc_id                  = "${aws_vpc.core_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}a"

  tags {
    Name       = "pubsub1"
    cidr_block = "10.0.1.0/24"
  }
}

## Creating Public subnet it AZ B
resource "aws_subnet" "core_pub2" {
  vpc_id                  = "${aws_vpc.core_vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}b"

  tags {
    Name       = "pubsub2"
    cidr_block = "10.0.2.0/24"
  }
}

## Creating Private subnet it AZ A
resource "aws_subnet" "core_priv1" {
  vpc_id                  = "${aws_vpc.core_vpc.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.region}a"

  tags {
    Name       = "privsub1"
    cidr_block = "10.0.3.0/24"
  }
}

## Creating Private subnet it AZ B
resource "aws_subnet" "core_priv2" {
  vpc_id                  = "${aws_vpc.core_vpc.id}"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.region}b"

  tags {
    Name       = "privsub2"
    cidr_block = "10.0.4.0/24"
  }
}

## Creating RDS subnet it AZ A
resource "aws_subnet" "core_rds1" {
  vpc_id                  = "${aws_vpc.core_vpc.id}"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.region}a"

  tags {
    Name       = "rdssub1"
    cidr_block = "10.0.5.0/24"
  }
}

## Creating RDS subnet it AZ B
resource "aws_subnet" "core_rds2" {
  vpc_id                  = "${aws_vpc.core_vpc.id}"
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.region}b"

  tags {
    Name       = "rdssub2"
    cidr_block = "10.0.6.0/24"
  }
}

## Creating Internet gateway
resource "aws_internet_gateway" "core_igw" {
  vpc_id = "${aws_vpc.core_vpc.id}"
  tags {
        Name = "core_IGW"
    }
}

## Adding Internet gateway to main routing table
resource "aws_route" "core_internet_access" {
  route_table_id         = "${aws_vpc.core_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.core_igw.id}"
}

## Creating Elastic IP for use with NAT gateway
resource "aws_eip" "core_nat_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.core_igw"]
}

## Creating NAT gateway
resource "aws_nat_gateway" "core_natgw" {
    allocation_id = "${aws_eip.core_nat_eip.id}"
    subnet_id = "${aws_subnet.core_pub1.id}"
    depends_on = ["aws_internet_gateway.core_igw"]
}

## Creating private routing table
resource "aws_route_table" "core_private_rt" {
    vpc_id = "${aws_vpc.core_vpc.id}"

    tags {
        Name = "Private route table"
    }
}

## Adding NAT route to private routing table
resource "aws_route" "core_nat_route" {
  route_table_id  = "${aws_route_table.core_private_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.core_natgw.id}"
}

## Adding public subnets to main routing table
resource "aws_route_table_association" "core_pub1_association" {
    subnet_id = "${aws_subnet.core_pub1.id}"
    route_table_id = "${aws_vpc.core_vpc.main_route_table_id}"
}

resource "aws_route_table_association" "core_pub2_association" {
    subnet_id = "${aws_subnet.core_pub2.id}"
    route_table_id = "${aws_vpc.core_vpc.main_route_table_id}"
}

## Adding private subnets to private routing table
resource "aws_route_table_association" "core_priv1_association" {
    subnet_id = "${aws_subnet.core_priv1.id}"
    route_table_id = "${aws_route_table.core_private_rt.id}"
}

resource "aws_route_table_association" "core_priv2_association" {
    subnet_id = "${aws_subnet.core_priv2.id}"
    route_table_id = "${aws_route_table.core_private_rt.id}"
}

## Adding RDS subnets to private routing table
resource "aws_route_table_association" "core_rds1_association" {
    subnet_id = "${aws_subnet.core_rds1.id}"
    route_table_id = "${aws_route_table.core_private_rt.id}"
}

resource "aws_route_table_association" "core_rds2_association" {
    subnet_id = "${aws_subnet.core_rds2.id}"
    route_table_id = "${aws_route_table.core_private_rt.id}"
}


############### OUTPUTS ###############
output "output_vpc_id" {
  value = "${aws_vpc.core_vpc.id}"
}
