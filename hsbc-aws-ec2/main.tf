data "aws_vpc" "demo" {
  filter {
    name = "tag:Environment"
    values = ["demo"]
  }
}
