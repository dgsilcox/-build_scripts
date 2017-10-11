provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module static {
  source = "static/"

  security_groups = "${module.static.website-sg}"
  subnet_ids = "subnet-5ee4fd16"
}
/* */
 module "blue" {
  source = "blue/"

  aws_elb_lb_id = "${module.static.aws_elb_lb_id}"
  security_groups = "${module.static.website-sg}"
  subnet_ids = "subnet-5ee4fd16"
  image_id = "ami-4fffc834"
  instance_type = "t2.micro"
  sns_topic_name = "${module.static.aws_topic_arn}"
  key_name = "dgsilcoxkeypair" }
 /* */
/*
module "green" {
  source = "green/"

  aws_elb_lb_id = "${module.static.aws_elb_lb_id}"
  security_groups = "${module.static.website-sg}"
  subnet_ids = "subnet-5ee4fd16"
  image_id = "ami-4fffc834"
  instance_type = "t2.micro"
  sns_topic_name = "${module.static.aws_topic_arn}"
  key_name = "dgsilcoxkeypair"
 }
  */