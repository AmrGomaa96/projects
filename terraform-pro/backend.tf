# # apply
# terraform{
#     backend "s3" {
#         bucket = "terraform-statefiles-itilabs2023"
#         #add the directory name in the key section
#         key = "dev/terraform.tfstate"
#         region = "us-east-1"
#         dynamodb_table = "terraform_locks"
#         encrypt =   true

#     }
# }     