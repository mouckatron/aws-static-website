
locals {
  subdomain = (var.sub_domain ? "${var.appname}." : "")
  domain    = "${local.subdomain}${var.root_domain}"
}
