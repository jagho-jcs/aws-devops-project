output "alb_dns_name" {
  value = "${aws_alb.hsbc_alb.dns_name}"
}

# output "instance_ip_addr" {
#   value = aws_instance.web-instance.private_ip
# }