# AWS Networking Terraform module

Terraform module which creates a VPC, Subnets, Internet Gateway and Route Table associations on AWS with all (or almost all) features provided by Terraform AWS provider.

## Usage


Example:

```hcl
module "web" {
  source  = "app.terraform.io/example-org-6cde13/networking/aws"
  version = "1.0.0"
  username = var.username
  projectname = "operator.ui"
  settingsjson = "{ \"path\":\"test\" }"  
}
```
