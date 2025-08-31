output "bucket_id" {
  description = "ID do bucket S3"
  value       = aws_s3_bucket.bucket.id
}

output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_domain_name" {
  description = "Domain name do bucket S3"
  value       = aws_s3_bucket.bucket.bucket_domain_name
}

output "bucket_versioning_status" {
  description = "Status do versionamento"
  value       = aws_s3_bucket_versioning.bucket_versioning.versioning_configuration[0].status
}
