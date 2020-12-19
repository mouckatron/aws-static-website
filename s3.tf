
## Static Site #################################################################
resource "aws_s3_bucket" "frontend" {
  bucket = local.domain
  acl    = "private"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }

  tags = {
    appname = var.appname
  }
}

data "template_file" "frontend_policy" {
  template = file("${path.module}/s3-bucket-policy.json")
  vars = {
    s3_bucket = aws_s3_bucket.frontend.id
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.template_file.frontend_policy.rendered
}


## Codepipeline ################################################################
resource "aws_s3_bucket" "codepipeline" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.appname}-codepipeline"
  acl    = "private"

  tags = {
    appname = var.appname
  }
}
