variable "project_id" {
  description = "GCP Project Id"
  type        = string
}

variable "environment" {
  description = "Environment"
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


