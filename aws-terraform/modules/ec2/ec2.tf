resource "aws_instance" "myec2" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  key_name                    = "terraform"
  subnet_id                   = var.public_subnet_id[count.index]

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
      private_key = base64decode("LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBa3VMYlBIRjRPcWVwNzVpdEVhdjVNaklsZmtEZndLbC8wbmpVNGRWNmR3bFB1cjVTCk83UkwwU0czQ2dtQ3FzZnhiYXpxYVN0L2tHTjN3MVNoWjAzSzF5L1pyS1krSEx4MjRocGVnQWRLaGZqS1JUSWQKSzIxNHRpbVFDTENRbkFWUmZCOERHcUZFS012NlFOZ1U3alJ3TUZQUXIzZVNRcUVncVBxcTdJeE9mTVNoUGgrYQp6R21DMXgrVVEvcHhmQ1dUdFpmUmJ6WGxLRWRXZTFLcncxRExoNDVmampMUlZTQnB2RThUWkthdTZKLzBYc09GCm1PM3RJNmFGNVdZQVM2M0EyQklxejQ3cDNnWE8vMFh6QUFQdmpPZytlNHh2UldodGErSndsRWRyL3BiNzE0ZjUKcnc1ZFhjY0NJYVRJM0ZVL3VzUVpweDViaSt6Wld5WGVlVlZiZFFJREFRQUJBb0lCQVFDTjIxTzZPeWZQRmUvVAp1cEtpdDRDeVRxWFJHZHcrV0RSZlUxemRRZXZGSEpRSW1SZ1lHeGNCd1ZyaDhhOWxPalpiSXAwOHRzcTY2cVZXCld0eUtSU0g1MG5lWit1K1BseUFGVzB3YXYyL2tsUkxiNHZzeTNzV3V2OU1mNFUyM3NKY3lsVXpOSWlRT2RuaVkKdVZiMWVtVkM5eDlhNXRLMVVLR1hNSWQwYmtpNnl6K0k2aTNheUVLNE0rSE83SUE0TGIwLzZFN2VLa0JKUU1RYwpWdEhqbk1TQUE0WEkrazU0cy9HbzZuK1IveTJod1RLbFh4eG5iK3U0ZmpoR1VVVWtXQk5vQnRraDlsYld6Ky9ZCmdaZ2tPS05xQWVqRW94eE1QWFhGSVEzVmxRRGorRm96Ym9EbitlQytWUVIzTTRzL2NDSkl6Z1owMVNlcWpuWCsKM25zUW13aEJBb0dCQU5SVktnZVNsKzVJdVZTeUl2b1Z6TEhlUVpzRnUybW1ueWQ2RnNvR2NMMDJMVG1FdGFBcwpHSzhoNlFZYWFvZWN2TG45SWxpYjdxeGYrbE4xMWhBbllBTDg4L0FBUTRET2VhODlPSW0xdkEwYllJNzVqZW5OCkNtaVAvNnhUUitMeHd5VVVpd29DaHBFVTNGZTZPcHNXU1hXWXdTSStiRnBVcm9vQ3dERXZpTFpsQW9HQkFMRVkKRkxwcEwzckdDUjJPQVl6ODBFUnVnemJ1ajJNNFhQTjVpeEZRU2Y5d09tbmFLbmZvNkg2U2tVZU5OanpWcXBPZAo2cUxhSTRKRk5Dd0xBMmx1WkswTXcvaldkSzdoSUtGRVZHelluMEpjU0RGdHg0YXVvcjhFWEpTV3UrUGp3OUUyCmx4c2d5SmRESTBXU3Z0SHRWSnRxd3hOYXI2WVMrV2NMdVdvSmVmZlJBb0dCQUlZWHNvOU51TDAzR0RPd3UvNEwKdmxXbDh2Q2YwaGVLcm9BVHpraVBnS3M5aDVvSGdWeEIvT1M5R1poTkhuRytQa0dHNXlYbWMvaFFOSnA0bEZObgpTbThZcUVVdEpYUTI4UW9HTTZwa0p2cHdDNjYvVXl3UDNUN2prYWVXZ0pPRjhxTjhNY0tFamM4WnlYMXRrbzFXCnFkV21QbklOMGdmSjZ1QWxsSko3WG04eEFvR0JBSkg2YmF1elpPWHBORDVlZmp5L2NOWFgydVYvQkVjZmdNOWEKRXg1MGRtclBFZmVMVkpKL05KYVJMcHd5ZE5EMHQ2VHkrU1RBZDZDOGR1TVBPUUxCY3MrS3hFZnNUMGFRWUp0TwpmZUV6TnlRMmVYUDFNQkYvQnJ3NlZpNU5paGV4K2dvTTI4WUs0ZzU5MHlkWWJWOFNLVG5yYVY0YzFNa3F2dGNJClBSQ0JPejdoQW9HQUFZUFI3M0JSWkNNZ28xSXJnR1pDUThKeitvekJSbGE2KzVxRzUrKzd6MU5jZGp3WkwyQ24KTVB5R0pZdVpuSzJhZmNNcGY1ZDVsWmNObFRkdDVTVXlZTjhzUUhYQUV5UnhqSC85SlRCektPZDJ1aDNxck9tdgozcStscy92SFY1cWJqK3h2QTR2c0RQdk5GSlg0UXRyUTNQNUZ4MWRxQ2lWb05TNUtmT3lKaVdVPQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQ")
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