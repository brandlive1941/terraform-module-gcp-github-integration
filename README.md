# terraform-module-gcp-github-integration
===========

A terraform module to provide GitHub Actions and Cloud Build connections with GCP using Workload Identity Federation.

Module Input Variables
----------------------

- `project_id` - GCP project id (required)
- `project_number` - GCP project number (required)
- `region` - GCP region (default: us-west1)
- `github_org` - Github organization (required)
- `github_token` - Github token (required)
- `github_app_cloudbuild_installation_id` - Github App Cloud Build Installation Id (required)
- `terraform_repo_name` - Terraform repository name (default: terraform-gcp)
- `name` - Pool provider name (optional)

Usage
-----

```hcl
module "github_integration" {
  source         = "github.com/brandlive1941/terraform-module-gcp-github-integration?ref=v1.2.0"
  project_id     = var.project_id
  project_number = var.project_number  # Required - get from GCP console or gcloud
  github_org     = var.github_org
  github_token   = var.github_token
  github_app_cloudbuild_installation_id = var.github_app_cloudbuild_installation_id
}
```

**Note:** `project_number` is required and must be passed explicitly. You can get it from GCP Console or by running:
```bash
gcloud projects describe PROJECT_ID --format="value(projectNumber)"
```

Outputs
=======
 - `service_account_email` - Service Account Email
 
 The following are usable in Github Actions, see see: https://github.com/google-github-actions/auth
 - `google_service_id` - Service Account ID 
- `workload_identity_pool_provider_id` - Workload Identity Pool  Provider ID

Authors
=======

drew.mercer@brandlive.com
