output "service_account_id" {
  description = "Service Account ID used by GitHub integration"
  value       = google_service_account.github.id
}

output "service_account_email" {
  description = "Service Account Email used by GitHub integration"
  value       = google_service_account.github.email
}

output "workload_identity_pool_provider_id" {
  description = "Workload Identity Pool Provider ID"
  value       = "${google_iam_workload_identity_pool.github.name}/providers/github-provider"
}