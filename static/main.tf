resource "aws_elb" "web" {
  name = "webserver-elb"

  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${var.security_groups}"]
  # instances       = ["${aws_instance.webserver.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}