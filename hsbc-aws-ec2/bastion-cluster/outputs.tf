output "instance_ips" {
  value = ["${aws_instance.bastion-host.*.public_ip}"]
}