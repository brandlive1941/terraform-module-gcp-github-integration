output "WIF_SERVICE_ACCOUNT" {
  description = "Service Account ID used by GitHub integration"
  value       = google_service_account.github.id
}

output "WIF_PROVIDER" {
  description = "Workload Identity Pool Provider Name"
  value       = "${google_iam_workload_identity_pool.github.name}/providers/github-provider"
}