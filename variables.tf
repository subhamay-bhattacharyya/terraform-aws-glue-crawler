/*
###################################################################################################
# Terraform Variables Configuration
#
# Description: This module creates an Glue Crawler using Terraform.
#
# Author: Subhamay Bhattacharyya
# Created: 18-Nov-2024 
# Version: 1.0
#
####################################################################################################
*/

######################################## AWS Configuration #########################################
variable "aws-region" {
  type    = string
  default = "us-east-1"
}

######################################## Project Name ##############################################
variable "project-name" {
  description = "The name of the project"
  type        = string
  default     = "your-project-name"
}

######################################## Environment Name ##########################################
variable "environment-name" {
  type        = string
  description = <<EOF
  (Optional) The environment in which to deploy our resources to.

  Options:
  - devl : Development
  - test: Test
  - prod: Production

  Default: devl
  EOF
  default     = "devl"

  validation {
    condition     = can(regex("^devl$|^test$|^prod$", var.environment-name))
    error_message = "Err: environment is not valid."
  }
}

######################################## Glue Crawler Configuration ################################
variable "glue-crawler-base-name" {
  description = "The base name of the Glue Crawler"
  type        = string
}

variable "glue-crawler-role-arn" {
  description = "The ARN of the IAM role that the Glue Crawler will use"
  type        = string
}

variable "glue-crawler-database-name" {
  description = "The name of the database in which the crawler's output will be stored"
  type        = string
}

variable "glue-crawler-table-prefix" {
  description = "The table prefix for the tables created by the crawler"
  type        = string
}

variable "glue-crawler-description" {
  description = "The description of the Glue Crawler"
  type        = string
  default     = "Glue Crawler created by Terraform"
}

variable "glue-crawler-configuration" {
  description = "The configuration for the Glue Crawler"
  type        = string
  default = jsonencode({
    "Version" = 1.0,
    "CrawlerOutput" = {
      "Partitions" = {
        "AddOrUpdateBehavior" = "InheritFromTable"
      }
    }
  })
}

variable "glue-crawler-targets" {
  description = "The targets for the Glue Crawler"
  type = map(object({
    s3 = map({
      path = string
    })
    }
  ))
  default = {
    s3 = null
  }
}

variable "schema-change-policy" {
  description = "The schema change policy for the Glue Crawler"
  type        = string
  default     = "UPDATE_IN_DATABASE"
}

variable "recrawl-policy" {
  description = "The policy for the Glue Crawler"
  type        = string
  default     = "CRAWL_EVERYTHING"
}

# Default tags for the Glue Crawler
variable "tags" {
  description = "A map of tags to assign to the Glue Crawler"
  type        = map(string)
  default = {
    Environment      = "devl"
    ProjectName      = "project-name"
    GitHubRepository = "test-repo"
    GitHubRef        = "refs/heads/main"
    GitHubURL        = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    GitHubSHA        = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  }
}

# Glue Crawler tags
variable "glue-crawler-tags" {
  description = "A map of tags to assign to the crawler"
  type        = map(string)
  default     = null
}

######################################## GitHub ####################################################
# The CI build string
variable "ci-build" {
  description = "The CI build string"
  type        = string
  default     = ""
}

######################################## Local Variables ###########################################
locals {
  glue-crawler-name = "${var.project-name}-${var.glue-crawler-base-name}-${var.environment-name}-${var.aws-region}${var.ci-build}"
}