locals {
  name = var.github_org ? "gh-${var.github_org}" : "github-brandlive"
  
  githubSARoles = [
    "roles/resourcemanager.projectIamAdmin", # GitHub Integration identity
    "roles/secretmanager.admin",             # Secret Manager Admin
    "roles/editor",                          # allow to manage all resources
    "roles/iam.serviceAccountTokenCreator",  # allow to create tokens for service accounts
    "roles/container.clusterViewer",         # allow access to GKE
    "roles/iam.roleAdmin",                   # allow to manage roles
    "roles/run.admin"                        # allow to manage Cloud Run
  ]
  seretAdmins = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  ]
  secretAccessors = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
    "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com",
  ]
  githubTokenAccessors = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com",
  ]
  cloudBuildRoles = [
    "roles/cloudbuild.builds.builder",
    "roles/iam.serviceAccountUser",
    "roles/container.developer"
  ]
}

data "google_project" "project" {}

module "github_token" {
  source     = "github.com/brandlive1941/terraform-module-gcp-secret?ref=v1.0.0"
  project_id = var.project_id
  github_org = var.github_org
  repo_name  = var.terraform_repo_name
  name       = "github_token"
  value      = var.github_token
}

module "github_app_cloudbuild_installation_id" {
  source     = "github.com/brandlive1941/terraform-module-gcp-secret?ref=v1.0.0"
  project_id = var.project_id
  github_org = var.github_org
  repo_name  = var.terraform_repo_name
  name       = "github_app_cloudbuild_installation_id"
  value      = var.github_app_cloudbuild_installation_id
}

resource "google_project_iam_member" "cloudbuild_secret_admin" {
  for_each = toset(local.seretAdmins)

  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = each.value
}

resource "google_project_iam_member" "compute_secret_accessors" {
  for_each = toset(local.secretAccessors)

  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = each.value
}

data "google_iam_policy" "github_token_accessors" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = local.githubTokenAccessors
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = var.project_id
  secret_id   = module.github_token.id
  policy_data = data.google_iam_policy.github_token_accessors.policy_data
}

// Create the GitHub connection
resource "google_cloudbuildv2_connection" "organization" {
  provider = google-beta
  project  = var.project_id
  location = var.region
  name     = var.github_org

  github_config {
    app_installation_id = module.github_app_cloudbuild_installation_id.value
    authorizer_credential {
      oauth_token_secret_version = module.github_token.version
    }
  }
}

resource "google_service_account" "github" {
  project      = var.project_id
  account_id   = "github-${var.github_org}"
  display_name = "github integration used for actions and cloudbuild"
  description  = "link to Workload Identity Pool used by GitHub"
}

resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset(local.cloudBuildRoles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Allow to access all resources
resource "google_project_iam_member" "github_sa_roles" {
  for_each = toset(local.githubSARoles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.github.email}"
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = local.name
  display_name              = local.name
  description               = "for GitHub Integration"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "github-${var.github_org}"
  description                        = "OIDC identity pool provider for execution of GitHub Actions and Cloud Build integration"
  # See. https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.refs"             = "assertion.ref"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github" {
  service_account_id = google_service_account.github.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_owner/${var.github_org}"
}
