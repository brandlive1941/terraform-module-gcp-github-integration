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

 - `storage bucket fqdn` - FQDN of the bucket
 - `google_service_account` - Service Account used by GitHub integration
 - `service_account_github_email` - Service Account Email used by GitHub integration
 - `service_account_github_id` - Service Account ID used by GitHub integration
- `google_iam_workload_identity_pool` - Workload Identity Pool Provider Name

Authors
=======

drew.mercer@brandlive.com
