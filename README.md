# terraform bucket backend module
===========

A terraform module to provide github action and build connections

Module Input Variables
----------------------

- `project` - GCP project id
- `environment` - variable environment
- `githhub_org` - Github organization

Usage
-----

```hcl
module "github_integration" {
  source      = "../../../modules/github_integration"
  project_id  = var.project_id
  environment = var.environment
  github_org  = var.github_org
}
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
