output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}

output "alb_dns_name" {
  value = aws_lb.test.dns_name
}