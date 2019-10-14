output "instance_ips" {
  value = ["${aws_instance.web-instance.*.public_ip}"]
}

output "alb_address" {
  value = "${aws_alb.hsbc_alb.dns_name}"
}