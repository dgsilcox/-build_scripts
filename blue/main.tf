
resource "aws_autoscaling_group" "web-asg" {
  name                 = "webserver-asg-blue"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.web-lc.name}"
  vpc_zone_identifier = ["${var.subnet_ids}"]

  lifecycle {
    create_before_destroy = true
  }

  load_balancers       = ["${var.aws_elb_lb_id}"]

  #vpc_zone_identifier = ["${split(",", var.availability_zones)}"]

}

resource "aws_launch_configuration" "web-lc" {
  name          = "webserver-lc-blue"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"

  # Security group
  security_groups = ["${var.security_groups}"]
  key_name      = "${var.key_name}"
  user_data       = "${file("userdata.sh")}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_notification" "webserver-asg-notification" {
  group_names = [
    "${aws_autoscaling_group.web-asg.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]
  topic_arn = "${var.sns_topic_name}"
}