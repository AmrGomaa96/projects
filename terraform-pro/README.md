# Project Describtion 
### The purpose of the project is to build a web application in a private subnet with extra layer of security which is the public instances act a proxy and an application load balancer.

<img title="a title" alt="Alt text" src="https://user-images.githubusercontent.com/116598689/219270943-ed491948-f61e-4046-b05c-a7e9d271bec2.png">

#
## Project components 
### - VPC
### - 2 Private subnets (different Az)
### - 2 Public subnets (different Az)
### - Nat Gatewat
### - Internet Gateway
### - 2 Private instance with apache web server
### - 2 Public instance with Nginx web server
### - Application LoadBalancer 
### - Network LoadBalancer

#

## Building the Environment

### Using Terraform:
#### In order to prepare the current working directory for use with Terraform.
```
terraform init
```
#### To check the build before running
```
terraform plan
```
#### To build
```
terraform apply 
```

#
# Saving terraform state files
### Create s3 with versioning option to prevent overwrite.
### Create Dynamodb to apply state lock
### Create a backend terraform file then :
```
terraform init
```