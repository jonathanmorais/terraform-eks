#vpc configuration
resource "aws_vpc" "vpc01" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "eks-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "subnet01" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.vpc01.id}"

  tags = "${
    map(
     "Name", "eks-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "gateway01" {
  vpc_id = "${aws_vpc.vpc01.id}"

  tags = {
    Name = "terraform-eks"
  }
}

resource "aws_route_table" "routeTable01" {
  vpc_id = "${aws_vpc.vpc01.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway01.id}"
  }
}

resource "aws_route_table_association" "routeTableAss01" {
  count = 2

  subnet_id      = "${aws_subnet.subnet01.*.id[count.index]}"
  route_table_id = "${aws_route_table.routeTable01.id}"
}

