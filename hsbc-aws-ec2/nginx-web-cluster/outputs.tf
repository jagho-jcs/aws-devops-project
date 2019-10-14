output "instance_ips" {
  value = ["${aws_instance.web-instance.*.public_ip}"]
}