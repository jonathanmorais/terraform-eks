# iam role configuration

resource "aws_iam_role" "cluster-dev01" {
  name = "cluster-dev01"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-dev01-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.cluster-dev01.name}"
}

resource "aws_iam_role_policy_attachment" "cluster-dev01-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.cluster-dev01.name}"
}

# Cluster Security Group

resource "aws_security_group" "cluster-dev01" {
  name        = "cluster-dev01"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.vpc01.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cluster-dev01"
  }
}

# EKS Master Cluster

resource "aws_eks_cluster" "master-cluster" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.cluster-dev01.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster-dev01.id}"]
    subnet_ids         = ["${aws_subnet.subnet01.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-dev01-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.cluster-dev01-AmazonEKSServicePolicy",
  ]
}