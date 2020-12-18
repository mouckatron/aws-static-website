resource "aws_codecommit_repository" "infrastructure" {
  repository_name = "${var.appname}-infrastructure"
  description     = "${var.appname} - Terraform Infrastructure Repo"
  tags = {
    appname = var.appname
  }
}

resource "aws_codecommit_repository" "sitecode" {
  repository_name = "${var.appname}-sitecode"
  description     = "${var.appname} - static site code"
  tags = {
    appname = var.appname
  }
}
