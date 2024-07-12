output "google_service_account" {
  description = "Service Account used by GitHub integration"
  value       = google_service_account.github.name
}

output "service_account_github_email" {
  description = "Service Account Email used by GitHub integration"
  value       = google_service_account.github.email
}

output "service_account_github_id" {
  description = "Service Account ID used by GitHub integration"
  value       = google_service_account.github.id
}

output "google_iam_workload_identity_pool" {
  description = "Workload Identity Pool Provider Name"
  value       = google_iam_workload_identity_pool.github.name
}
