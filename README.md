# Challenge with Terraform
This challenge will create a VCP with Internet Gateway, private and public subnets two each accross 2 Avialability zones in AWS  using
and terraform and also deploy the following resources:

- A bastion/jumpbox host into the public subnet in Avialability Zone a and a second instance called node in the private subnet in Availability Zone b, 
 which can connect to the internet via a NAT gateway created as part of the VPC.

- An SSH key pair which will be dynamically generated as well and the private key copied over to the bastion/jumpbox host.

- Two security groups, one allowing access via port 22 eternally and the other allowing traffic via port 22 only from the public subnets.
  The The bastion/jumbox host  in the public subnet is assigned to the security group with external or internet access via port 22 for ssh and the node instance in the private 
  subnet is assigned to the security group that only allows ssh access from the VPC public subnet hosting the bastion/jumpbox host. 
  
  Note that you can also tie the public access connection to a secure IP or VPN and both security groups are dynamically created in the network module.


# Modules
For simplicity purposes I've broken down this deployment into three main modules and did also used well structured modules from Terraform AWS to facilitate
the creation of some of the resources needed for this challenge. The modules used are describe below:

- ## ssh-key: 
  Which generates an ssh key pair use to access the instances

- ## network: 
  Creates a VPC with IGWs, NAT GWs, 2 public and 2 private subnets each in a different Availability Zone, Security Groups to SSH to bastion/jumpbox host from the internet and within the VPC.
  
  NB in this module I referenced terraform-AWS VPC moudle from Terraform registry to facility the creations of RT and other netwok configs 

- ## ec2: 
  This module creates two Amazon Linux 2 t2.micro instances, one called jumbox in the public subnet and the other called node in private subnet
  The private key generated by the ssh-key module  is copied over to the jumbox which is then use to access the node instance in the private subnet via ssh

  Note that the node instance in private subnet can reach the internet or external networks though the NAT gateway making it easy to ping or curl google.com

## Provider

The provider used in this case is aws with more detail found in provider.tf located in  the project' root

# Requirements.
For this to work you will need to install terraform 1.2.6 (currently latest). I you do not have Terraform installed please go to https://www.terraform.io/downloads for more assistance.
You will also need an AWS Access and Secret keys with Admin privileges for programatic access

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | The project namespace to use for unique resource naming | `string` | `"allamerica-challenge"` | no |
| region | AWS region | `string` | `"us-east-1"` | no |
| acces_key | AWS Access Key | `string` | `"enter your aws access key here"` | yes |
| secret_key | AWS Secret Key | `string` | `"enter your aws secret key here"` | yes |


## Outputs

| Name | Description |
|------|-------------|
| public\_connection\_string | SSH connection strings to access jumpbox |
| private\_connection\_string | SSH connection string to access private instance also called node |


