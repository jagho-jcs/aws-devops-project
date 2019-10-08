# output "id" {
#   value = "${element(aws_subnet.pub_sub_1a.*.id, 0)}"
# }

output "pub_sub_1a" {
  value = "${aws_subnet.pub_sub_1a.*.cidr_block}"
}

output "pub_sub_1b" {
  value = "${aws_subnet.pub_sub_1b.*.cidr_block}"
}

output "pub_sub_1c" {
  value = "${aws_subnet.pub_sub_1c.*.cidr_block}"
}