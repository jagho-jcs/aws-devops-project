variable "aws_region" {
  description = "AWS region"
}

# Block sizes must be between a /16 netmask and /28 netmask
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
}

# VPC Name tag
variable "vpc_tg" {
  description = "VPC for deploying to Staging"
}

#  Internet Gateway Name Tag
variable "igw_tg" {
  description = "Internet Gateway"
  default     = "igw_stg"
}
# Grant the VPC internet access on its main route table
variable "destination_cidr_block" {
  type = "string"
  description = "describe your variable"
}

#  Load Balancer Name Tag
variable "ire_alb_tg" {
  description = "Allows all traffic from the Application Load Balancer"
  default     = "InFacingALB"
}

# Security Group Name Tag
variable "ssh_admin_tg" {
  description = "Allows SSH admin access"
  default     = "SSH"
}

#  Security Group Name Tag
variable "jcswebapps_tg" {
  description = "Allows SSH admin access"
  default     = "JCSWebAppsALB"
}

#  Security Group Name Tag
variable "efs_tg" {
  description = "Allows SSH admin access"
  default     = "EFS"
}

#  Security Group Name Tag
variable "jks_tg" {
  description = "Allows Access to the Jenkins Dashboard"
  default     = "JenkinsMastersSG"
}

#  Public Subnet Name Tag
variable "pub_sub_1a_tg" {
  description = "Public Subnet 1a Name Tag"
  default     = "Public Subnet 1a"
}

#  Public Subnet Name Tag
variable "pub_sub_1b_tg" {
  description = "Public Subnet 1b Name Tag"
}

#  Public Subnet Name Tag
variable "pub_sub_1c_tg" {
  description = "Public Subnet 1c Name Tag"
}

#  Public Route Table Name Tag
variable "pub_rtb_tg" {
  description = "Public Route Table Name Tag"
  default     = "Public Route Table"
}

#  Public Network ACL's Name Tag
variable "acls_pub_prod_tg" {
  description = "Public Network ACL's Name Tag"
  default     = "ACLS Public"
}