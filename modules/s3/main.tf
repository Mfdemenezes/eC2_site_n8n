terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

# Criação do S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = "${local.sanitized_project_name}-bucket-${random_id.sufixo.hex}"
  force_destroy = true # Permite destroy mesmo com objetos

  tags = {
    Name        = "${var.project_name}-s3-bucket"
    Environment = var.environment
  }
}

# Local para sanitizar o nome do projeto
locals {
  # Converte para minúsculas e substitui underscores por hífens
  sanitized_project_name = lower(replace(var.project_name, "_", "-"))
}

# Configuração de versionamento do bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Configuração de criptografia
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Configuração de acesso público
resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

# Recurso para gerar sufixo único
resource "random_id" "sufixo" {
  byte_length = 4
}
