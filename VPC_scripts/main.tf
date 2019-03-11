terraform {
  backend "s3" {
    bucket = "shiv-terraform-state"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"
  }
}

#####Configuring the provider as AWS.

provider "aws" {
  region = "${var.aws_region}"
}

##### Creating a VPC in user specified region.

resource "aws_vpc" "main" {
  count = 2
  cidr_block           = "${element(var.cidr_prefix, count.index)}.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${var.vpc_name}${count.index}"
  }
}

##### Creating 6 subnets of which 3 are in AZ - "a" and 3 in AZ - "b".

resource "aws_subnet" "private_subnet" {
  count = 6
  vpc_id            = "${aws_vpc.main.0.id}"
  cidr_block        = "${element(var.cidr_prefix, 0)}.${count.index}.0/24"
  availability_zone = "${element(var.availability_zone,count.index)}"

  tags {
    Name = "${var.vpc_name}-priv-a${count.index}"
  }
}

##### Creating a virtual private gateway and attaching it to the created VPC.

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.main.0.id}"

  tags {
    Name = "gateway-of-india"
  }
}

##########################
# VPC peering connection #
##########################
resource "aws_vpc_peering_connection" "this" {
  count = "${var.create_peering ? 1 : 0}"
  peer_owner_id = "${var.owner_account_id}"
  peer_vpc_id   = "${aws_vpc.main.0.id}"
  vpc_id        = "${aws_vpc.main.1.id}"
  auto_accept   = "${var.auto_accept_peering}"
}


##### Printing the peering connection Id.

output "vpc_peering_id" {
  description = "Peering connection ID"
  value       = "${element(concat(aws_vpc_peering_connection.this.*.id, list("")),0)}"
}
