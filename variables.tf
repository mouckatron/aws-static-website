
variable "appname" {
  description = "Name of your app, used as name or prefix for resources and applied as tag for cost tracking"
  type        = string
}

variable "root_domain" {
  description = "Root domain which this app will be hosted at"
  type        = string
}

variable "sub_domain" {
  description = "true: host at <appname>.<root_domain>, false: host at <root_domain>"
  type        = bool
  default     = false
}
