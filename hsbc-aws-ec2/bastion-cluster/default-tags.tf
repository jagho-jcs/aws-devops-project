variable "demo_env_default_tags" {
  type        = map(string)
  description = "Default tags to be applied to all resources created in the demo environment"
  default = {
    ConsultantName = "Yomi Ogunyinka"
    Position       = "Solutions Architect"
    ProvisionedBy  = "Terraform"
    Location       = "Dublin"
    DataCenter     = "New Business"
    Team           = "DevOps"
    CostCentre     = "Operations"
  }
}