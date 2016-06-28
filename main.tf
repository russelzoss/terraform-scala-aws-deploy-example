# Start up an AWS instance from the AMI created with packer

provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_key_pair" "auth" {
    key_name   = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

# Security group to access via SSH
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Default security group"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "app"
  description = "App security group"

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
    ami = "${lookup(var.aws_amis, var.aws_region)}"
    instance_type = "t2.micro"
    security_groups = [
        "${aws_security_group.ssh.name}",
        "${aws_security_group.app.name}"
    ]
    key_name = "${aws_key_pair.auth.id}"
    tags {
        Name = "HelloWorld"
    }

    connection {
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

    # Provision the AWS Instance with our application build as a debian package
    provisioner "file" {
        source = "target/helloworld_1.0-SNAPSHOT_all.deb"
        destination = "/tmp/helloworld_1.0-SNAPSHOT_all.deb"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "sudo dpkg -i /tmp/helloworld_1.0-SNAPSHOT_all.deb",
            "sudo chown -Rh root:root /usr/share/helloworld",
            "sudo chown helloworld /usr/share/helloworld"
        ]
    }
}

output "ip" {
    value = "${aws_instance.app.public_ip}"
}

# RDS stuff
resource "aws_db_instance" "default" {
    instance_class      = "db.t1.micro"
    snapshot_identifier = "arn:aws:rds:eu-west-1:617080272517:snapshot:thehalasnapshot"
}


