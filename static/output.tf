output "aws_elb_lb_id" {
  value = "${aws_elb.web.id}"
}

output "aws_topic_arn" {
  value = "${aws_sns_topic.dgsilcox_sns_topic.arn}"
}

output "website-sg" {
  value = "${aws_security_group.website-sg.id}"
}