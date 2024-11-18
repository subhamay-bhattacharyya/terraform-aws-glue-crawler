/*
####################################################################################################
# Terraform Glue Job Outputs Configuration
#
# Description: This module creates an Glue Crawler using Terraform.
#
# Author: Subhamay Bhattacharyya
# Created: 18-Nov-2024 
# Version: 1.0
#
####################################################################################################
*/


# --- Glue Crawler Outputs ---
output "glue-crawler-id" {
  description = "The ID of the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.id
}

output "glue-crawler-arn" {
  description = "The ARN of the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.arn
}

output "glue-crawler-name" {
  description = "The name of the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.name
}

output "glue-crawler-role_arn" {
  description = "The ARN of the IAM role used by the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.role
}

output "glue-crawler-database_name" {
  description = "The name of the database used by the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.database_name
}

output "glue-crawler-table-prefix" {
  description = "The table prefix used by the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.table_prefix
}

output "glue-crawler-description" {
  description = "The description of the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.description
}

output "glue-crawler-configuration" {
  description = "The configuration of the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.configuration
}

output "glue-crawler-targets" {
  description = "The targets of the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.targets
}

output "glue-crawler-tags" {
  description = "The tags assigned to the Glue Crawler"
  value       = aws_glue_crawler.glue_crawler.tags
}

output "security_configuration_id" {
  description = "The ID of the Glue Job Security Configuration"
  value       = aws_glue_security_configuration.security_configuration.id
}