# Terraform-work

clone the repo to you vs code after cloning the repo 

before applying below commands, create access_key and secret_key 

apply some Terraform commands to execute you infrastructure 

1) terraform init :- it will initialise all required providers into it
2) terraform validate :- it will validate your configuration 
3) terraform plan ;- it will show you what it will going to be execute
4) terraform apply :- apply to provision you infrastructure 
5) terraform destroy :- use this to destroy your infrastructure after creating it.

you can also use --auto-approve at the end of terraform apply command 

go the aws console and into ec2->section -> load-balancer-> in that add rules for orders, payments, and for bookings to route the traffic to partlicular instances 
