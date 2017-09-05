
resource "aws_instance" "webserver" {
  ami           = "ami-4fffc834"
  instance_type = "t2.micro"
  key_name      = "dgsilcoxkeypair"
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

resource "aws_eip" "ip" {
  instance = "${aws_instance.webserver.id}"
}

resource "aws_elb_attachment" "baz" {
  elb      = "${var.aws_elb_lb_id}"
  instance = "${aws_instance.webserver.id}"
}


