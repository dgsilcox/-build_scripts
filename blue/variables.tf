variable "region" {
  default = "us-east-1"
}
variable "security_groups" {}
variable "subnet_ids"{}
variable aws_elb_lb_id{}

variable asg_max{
  default = "3"
}
variable asg_min {
  default = "1"
}

variable asg_desired {
  default = "1"
}

variable image_id {}

variable instance_type {}

variable sns_topic_name {}

variable key_name{}