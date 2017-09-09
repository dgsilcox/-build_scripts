/*
resource "aws_instance" "webserver" {
  ami           = "${var.image_id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  vpc_security_group_ids  = [
    "${var.security_groups}"
  ]

  provisioner "local-exec" {
      command = "echo ${aws_instance.webserver.public_ip} > ip_address.txt"
    }

  provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "chmod +x /tmp/script.sh",
        "sudo yum install -y httpd24 php56 php56-mysqlnd",
        "sudo chown -R ec2-user:ec2-user /var/www/html",
      ]
      connection {
                  user = "ec2-user"
                  private_key = "${file("dgsilcoxkeypair.pem")}"
                  host = "${self.public_ip}"
              }
  }

  provisioner "file" {
      source      = "script.sh"
      destination = "/tmp/script.sh"
      connection {
                        user = "ec2-user"
                        private_key = "${file("dgsilcoxkeypair.pem")}"
                        host = "${self.public_ip}"
                    }
  }

  provisioner "file" {
    source      = "../honest2dog/build/"
    destination = " /var/www/html"
    connection {
      user = "ec2-user"
      private_key = "${file("dgsilcoxkeypair.pem")}"
      host = "${self.public_ip}"
    }
  }

  provisioner "remote-exec" {
      inline = [
        "sudo service httpd start",
        "sleep 1",
      ]
      connection {
                  user = "ec2-user"
                  private_key = "${file("dgsilcoxkeypair.pem")}"
                  host = "${self.public_ip}"
              }
  }
}
*/

# resource "aws_eip" "ip" {
#  instance = "${aws_instance.webserver.id}"
# }

# resource "aws_elb_attachment" "baz" {
#  elb      = "${var.aws_elb_lb_id}"
#  instance = "${aws_instance.webserver.id}"
# }

resource "aws_autoscaling_group" "web-asg" {
  name                 = "webserver-asg"
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
  name          = "webserver-lc"
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