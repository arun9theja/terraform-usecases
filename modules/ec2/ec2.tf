resource "aws_instance" "myec2" {
  count                  = 2
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  key_name               = "terraform"
  subnet_id              = var.public_subnet_id[count.index]

  tags = {
    Name        = "server-${count.index}"
    Environment = "tqa"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd.x86_64",
      "sudo service httpd start",
      "sudo chkconfig httpd on",
      "sudo chmod 777 /var/www/html -R",
      "sudo echo 'Hello world' > /var/www/html/index.html",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/terraform.pem")
      host        = element(self.*.public_ip, count.index)
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "ec2-sg" {
  name        = "test-ec2-sg"
  description = "Allow ssh to EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "For ssh connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.access_ip]
  }
}

resource "aws_security_group_rule" "alb-to-ec2-ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2-sg.id
  source_security_group_id = var.alb_sg_id
}