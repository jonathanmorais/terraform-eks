module "eks" {
  source            = "./modules/eks"
  cluster-name       = "${var.cluster-name}"
  k8s-version        = "${var.k8s-version}"
  aws-region         = "${var.aws-region}"
  desired-capacity   = "${var.desired-capacity}"

data "aws_availability_zones" "available" {}

}