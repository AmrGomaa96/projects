resource "aws_s3_bucket" "terraform_state"{
    bucket = var.name
    lifecycle {
    #to prevent deletion
      prevent_destroy = true
    }
}

#to prevent overwrite
resource "aws_s3_bucket_versioning" "enable" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}