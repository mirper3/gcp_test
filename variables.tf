variable "project_id" {
  type           = string
  description  = "My project"
  default        = "lab-ssm-netsec-team"
}

variable "region" {
  type           = string
  description  = "Region for this infrastructure"
  default        = "europe-west8"
}

variable "name" {
  type           = string
  description  = "Name for this infrastructure"
  default       = "gcp-test"
}