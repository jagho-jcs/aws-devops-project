# output "alb_address" {
#   value = "${aws_alb.hsbc_alb.public_dns}"
# }

output "instance_ips" {
  value = ["${aws_instance.web-instance.*.public_ip}"]
}