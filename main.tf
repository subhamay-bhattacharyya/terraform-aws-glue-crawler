/*
####################################################################################################
# Terraform Glue Job Configuration
#
# Description: This module creates an Glue Crawler using Terraform.
#
# Author: Subhamay Bhattacharyya
# Created: 18-Nov-2024 
# Version: 1.0
#
####################################################################################################
*/

#--- Glue Crawler Configuration
resource "aws_glue_crawler" "glue_crawler" {
  # The name of the Glue Crawler.
  # This is a local variable defined elsewhere in the configuration.
  # Example: "my-glue-crawler"
  name = local.glue-crawler-name

  # A description of the Glue Crawler.
  # This is a variable defined elsewhere in the configuration.
  # Example: "This crawler scans the S3 bucket for new data."
  description = var.glue-crawler-description

  # The ARN of the IAM role that the Glue Crawler will use.
  # This is a variable defined elsewhere in the configuration.
  # Example: "arn:aws:iam::123456789012:role/service-role/AWSGlueServiceRole"
  role = var.glue-crawler-role-arn

  # The name of the Glue database where the crawler will create tables.
  # This is a variable defined elsewhere in the configuration.
  # Example: "my_glue_database"
  database_name = var.glue-crawler-database-name

  # A prefix to be added to the names of tables created by the crawler.
  # This is a variable defined elsewhere in the configuration.
  # Example: "crawler_"
  table_prefix = var.glue-crawler-table-prefix

  # --- Targets - S3
  # This block dynamically configures S3 targets for the AWS Glue Crawler.
  # It iterates over the "s3_target" key in the "glue-crawler-targets" variable.
  # If the "s3_target" key is not null, it creates a single instance of the s3_target block.
  # 
  # Parameters:
  # - path: The S3 path to be crawled.
  # - connection_name: The name of the connection to use for the S3 target.
  # - exclusions: A list of glob patterns to exclude from the crawl.
  # - sample_size: The size of the sample to be taken from the S3 target.
  # - event_queue_arn: The ARN of the event queue to use for the S3 target.
  # - dlq_event_queue_arn: The ARN of the dead-letter queue to use for the S3 target.
  dynamic "s3_target" {
    for_each = var.glue-crawler-targets["s3_target"] != null ? [1] : []
    content {
      path                = var.glue-crawler-targets["s3_target"]
      connection_name     = var.glue-crawler-targets["s3_target"].connection-name
      exclusions          = var.glue-crawler-targets["s3_target"].exclusions
      sample_size         = var.glue-crawler-targets["s3_target"].sample-size
      event_queue_arn     = var.glue-crawler-targets["s3_target"].event-queue-arn
      dlq_event_queue_arn = var.glue-crawler-targets["s3_target"].dlq-event-queue-arn
    }
  }

  # --- Target - JDBC ---
  # This block dynamically creates a JDBC target for the AWS Glue Crawler.
  # It checks if the "jdbc" key in the variable `glue-crawler-targets` is not null.
  # If it is not null, it creates a single JDBC target using the provided connection name and path.
  # The connection name and path are retrieved from the `glue-crawler-targets` variable.
  dynamic "jdbc_target" {
    for_each = var.glue-crawler-targets["jdbc"] != null ? [1] : []
    content {
      connection_name = var.glue-crawler-targets["jdbc_target"].connection-name
      path            = var.glue-crawler-targets["jdbc_target"].path
    }
  }

  # --- Target - DynamoDB
  # This dynamic block defines a DynamoDB target for the AWS Glue Crawler.
  # It iterates over the "dynamodb_target" key in the "glue-crawler-targets" variable.
  # If the "dynamodb_target" key is not null, it creates a single instance of the block.
  # The "path" attribute is set to the table name specified in the "dynamodb_target" key.
  dynamic "dynamodb_target" {
    for_each = var.glue-crawler-targets["dynamodb_target"] != null ? [1] : []
    content {
      path = var.glue-crawler-targets["dynamodb_target"].table-name
    }
  }

  # --- Target - Delta Lake
  # This dynamic block defines a delta_target configuration for the AWS Glue Crawler.
  # It iterates over the delta_target element in the glue-crawler-targets variable.
  # The block is included only if the delta_target element is not null.
  # 
  # Parameters:
  # - connection_name: The name of the connection to use for the delta target.
  # - create_native_delta_table: Boolean flag to create a native delta table.
  # - delta_tables: List of delta tables to be crawled.
  # - write_manifest: Boolean flag to write a manifest file.
  dynamic "delta_target" {
    for_each = var.glue-crawler-targets["delta_target"] != null ? [1] : []
    content {
      connection_name           = var.glue-crawler-targets["delta_target"].connection-name
      create_native_delta_table = var.glue-crawler-targets["delta_target"].create-native-delta-table
      delta_tables              = var.glue-crawler-targets["delta_target"].delta-tables
      write_manifest            = var.glue-crawler-targets["delta_target"].write-manifest
    }
  }

  # --- Target - Iceberg Table
  # Dynamic block to configure Iceberg target for AWS Glue Crawler
  # This block is only included if the "iceberg_target" is defined in the glue-crawler-targets variable.
  # 
  # Parameters:
  # - connection_name: The name of the connection to use for the Iceberg target.
  # - paths: A list of paths to include in the Iceberg target.
  # - exclusions: A list of paths to exclude from the Iceberg target.
  # - maximum_traversal_depth: The maximum depth to traverse when crawling the Iceberg target.
  dynamic "iceberg_target" {
    for_each = var.glue-crawler-targets["iceberg_target"] != null ? [1] : []
    content {
      connection_name         = var.glue-crawler-targets["iceberg_target"].connection-name
      paths                   = var.glue-crawler-targets["iceberg_target"].paths
      exclusions              = var.glue-crawler-targets["iceberg_target"].exclusions
      maximum_traversal_depth = var.glue-crawler-targets["iceberg_target"].maximum-traversal-depth
    }
  }

  # --- Target - Hudi
  # This dynamic block defines a "hudi_target" for the AWS Glue Crawler.
  # It iterates over the "hudi_target" element in the "glue-crawler-targets" variable.
  # The block is included only if "hudi_target" is not null.
  # 
  # Parameters:
  # - connection_name: The name of the connection to use for the target.
  # - paths: A list of paths to include in the crawl.
  # - exclusions: A list of paths to exclude from the crawl.
  # - maximum_traversal_depth: The maximum depth to crawl in the directory structure.
  dynamic "hudi_target" {
    for_each = var.glue-crawler-targets["hudi_target"] != null ? [1] : []
    content {
      connection_name         = var.glue-crawler-targets["hudi_target"].connection-name
      paths                   = var.glue-crawler-targets["hudi_target"].paths
      exclusions              = var.glue-crawler-targets["hudi_target"].exclusions
      maximum_traversal_depth = var.glue-crawler-targets["hudi_target"].maximum-traversal-depth
    }
  }

  # --- Target - MongoDB
  # This dynamic block defines a MongoDB target for the AWS Glue Crawler.
  # It iterates over the "mongodb_target" key in the "glue-crawler-targets" variable.
  # If the "mongodb_target" is not null, it creates a single instance of the block.
  # The block sets the following properties for the MongoDB target:
  # - connection_name: The name of the connection to the MongoDB instance.
  # - path: The path to the MongoDB collection.
  # - scan_all: A boolean indicating whether to scan all documents in the collection.
  dynamic "mongodb_target" {
    for_each = var.glue-crawler-targets["mongodb_target"] != null ? [1] : []
    content {
      connection_name = var.glue-crawler-targets["mongodb_target"].connection-name
      path            = var.glue-crawler-targets["mongodb_target"].path
      scan_all        = var.glue-crawler-targets["mongodb_target"].scan-all
    }
  }

  # --- Target - Catalog
  # This dynamic block defines a catalog target for the AWS Glue Crawler.
  # It iterates over the "catalog_target" key in the "glue-crawler-targets" variable.
  # If the "catalog_target" key is not null, it creates a catalog target with the following properties:
  # - connection_name: The name of the connection to use for the catalog target.
  # - database_name: The name of the database to use for the catalog target.
  # - tables: The list of tables to include in the catalog target.
  # - event_queue_arn: The ARN of the event queue to use for the catalog target.
  # - dlq_event_queue_arn: The ARN of the dead-letter queue to use for the catalog target.
  dynamic "catalog_target" {
    for_each = var.glue-crawler-targets["catalog_target"] != null ? [1] : []
    content {
      connection_name     = var.glue-crawler-targets["catalog_target"].connection-name
      database_name       = var.glue-crawler-targets["catalog_target"].database-name
      tables              = var.glue-crawler-targets["catalog_target"].tables
      event_queue_arn     = var.glue-crawler-targets["catalog_target"].event-queue-arn
      dlq_event_queue_arn = var.glue-crawler-targets["catalog_target"].dlq-event-queue-arn
    }
  }

  # Specifies the configuration for the AWS Glue Crawler.
  # This variable should be defined in the variables file and passed to the module.
  configuration = var.glue-crawler-configuration

  # This dynamic block defines the schema change policy for the AWS Glue Crawler.
  # It iterates over the schema-change-policy variable if it is not null.
  # The content block sets the update_behavior and delete_behavior based on the values provided in the schema-change-policy variable.
  # 
  # Variables:
  # - var.schema-change-policy: A map containing the schema change policy settings.
  #   - update-behavior: Specifies the update behavior for the schema change policy.
  #   - delete-behavior: Specifies the delete behavior for the schema change policy.
  dynamic "schema_change_policy" {
    for_each = var.schema-change-policy != null ? [1] : []
    content {
      update_behavior = var.schema-change-policy["update-behavior"]
      delete_behavior = var.schema-change-policy["delete-behavior"]
    }
  }

  # This dynamic block defines the recrawl_policy configuration for the AWS Glue Crawler.
  # It uses a conditional expression to check if the variable `recrawl-policy` is not null.
  # If `recrawl-policy` is not null, it creates a single instance of the recrawl_policy block.
  # The recrawl_behavior attribute within the recrawl_policy block is set to the value of `recrawl-policy`.
  dynamic "recrawl_policy" {
    for_each = var.recrawl-policy != null ? [1] : []
    content {
      recrawl_behavior = var.recrawl-policy
    }
  }

  # Assigns tags to the Glue Crawler resource. If the variable `glue-crawler-tags` is null, 
  # an empty map is assigned. Otherwise, the value of `glue-crawler-tags` is used.
  tags = var.glue-crawler-tags == null ? {} : var.glue-crawler-tags
}