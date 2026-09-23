variable "project_id" {
  description = "GCP Project Id"
  type        = string
}

variable "project_number" {
  description = "GCP Project Number (required for for_each to work at plan time)"
  type        = string
}

variable "region" {
  description = "GCP Project Region"
  type        = string
  default     = "us-west1"
}

variable "github_org" {
  description = "Github Organization"
  type        = string
}

variable "github_app_cloudbuild_installation_id" {
  description = "Github App Cloud Build Installation Id"
  type        = string
}

variable "github_token" {
  description = "Github Token"
  type        = string
}

variable "terraform_repo_name" {
  description = "Terraform Repository Name"
  type        = string
  default     = "terraform-gcp"
}

variable "name" {
  description = "Pool Provider Name"
  type        = string
  default     = ""
}

variable "secret_replication_locations" {
  description = "Regions to replicate the GitHub secrets to. Empty (the default) uses automatic replication, which stores them globally. Set this in projects whose org policy restricts resource locations, and set region to match."
  type        = list(string)
  default     = []
}
