variable "cluster-name" {
  default = "cluster-dev01"
  type    = "string"

}

variable "aws-region" {
  default     = "us-east-1"
  type        = "string"
  description = "The AWS Region to deploy EKS"
}

variable "k8s-version" {
  default     = "1.11"
  type        = "string"
  description = "Required K8s version"
}

variable "desired-capacity" {
  default     = 2
  type        = "string"
  description = "Autoscaling Desired node capacity"
}

variable "access_key" {
  type        = "string"
  default     = ""
}

variable "secret_key" {
  type        = "string"
  default     = ""
}