variable "project_id" {
  type           = string
  description  = "My project"
  default        = "project"
}

variable "region" {
  type           = string
  description  = "Region for this infrastructure"
  default        = "region"
}

variable "name" {
  type           = string
  description  = "Name for this infrastructure"
  default       = "gcp-test"
}
