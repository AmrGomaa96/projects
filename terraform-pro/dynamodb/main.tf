# to apply state lock
resource "aws_dynamodb_table" "terraform_locks" {
  name           = var.name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  attribute {
    name = var.attribute_name
    type = var.type
  }
}