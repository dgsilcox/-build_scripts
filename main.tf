provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module static {
  source = "static/"

  security_groups = "sg-2bcde55b"
  subnet_ids = "subnet-5ee4fd16"
}
/*
 module "blue" {
  source = "blueGreenResources/"

   aws_elb_lb_id = "${module.static.aws_elb_lb_id}"
  security_groups = "sg-2bcde55b"
  subnet_ids = "subnet-5ee4fd16"
 }
*/

module "green" {
  source = "blueGreenResources/"

  aws_elb_lb_id = "${module.static.aws_elb_lb_id}"
  security_groups = "sg-2bcde55b"
  subnet_ids = "subnet-5ee4fd16"
 }

