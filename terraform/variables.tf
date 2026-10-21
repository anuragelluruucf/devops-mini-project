variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "image" {
  type        = string
  description = "Full image ref, e.g. us-central1-docker.pkg.dev/PROJECT/ml-inference-demo/app:SHA"
}
variable "max_instances" {
  type    = number
  default = 3
}
variable "allow_public" {
  type    = bool
  default = false
}
