![](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/last-commit/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/release-date/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/repo-size/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/issues/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/languages/top/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/github/commit-activity/m/subhamay-bhattacharyya/terraform-aws-glue-database)&nbsp;![](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/244f96a721595aa305fcdae6f26a0424/raw/terraform-aws-glue-crawler.json?)

# Terraform AWS Glue Crawler Module

This Terraform module creates AWS Glue Crawler with various configurations.

## Usage

  Module Inputs:
  - `source`: The source of the module, specifying the registry and module path.
  - `version`: The version of the module to use.
  - `aws-region`: The AWS region where the Glue Crawler will be created.
  - `glue-crawler-name`: The name of the Glue Crawler.
  - `glue-crawler-role-arn`: The ARN of the IAM role that the Glue Crawler will assume.
  - `glue-crawler-database-name`: The name of the Glue database where the crawler will store metadata.
  - `glue-crawler-table-prefix`: The prefix to be added to the tables created by the crawler.
  - `glue-crawler-description`: A description of the Glue Crawler.
  - `glue-crawler-configuration`: A JSON-encoded string specifying the configuration of the Glue Crawler.
  - `glue-crawler-targets`: A map specifying the targets for the Glue Crawler, including S3 paths and connection details.
  - `schema-change-policy`: A map specifying the schema change policy for the Glue Crawler.
  - `recrawl-policy`: The recrawl policy for the Glue Crawler.
  - `glue-crawler-tags`: A map of tags to assign to the Glue Crawler.
 
 ```hcl
module "glue-crawler" {
  source  = "app.terraform.io/subhamay-bhattacharyya/glue-crawler/aws"
  version = "1.0.0"

  aws-region                 = "us-east-1"
  glue-crawler-name          = "glue-crawler-name"
  glue-crawler-role-arn      = "arn:aws:iam::123456789012:role/service-role/AWSGlueServiceRole"
  glue-crawler-database-name = "my-glue-database"
  glue-crawler-table-prefix  = "crawler-"
  glue-crawler-description   = "This crawler scans the S3 bucket for new data."
  glue-crawler-configuration = jsonencode({
    "Version" = 1.0,
    "CrawlerOutput" = {
      "Partitions" = {
        "AddOrUpdateBehavior" = "InheritFromTable"
      }
    }
  })
  glue-crawler-targets = {
    s3-target = {
      path                = "s3://example-bucket/data/"
      connection-name     = "my-s3-connection"
      exclusions          = ["s3://example-bucket/data/exclude/"]
      sample-size         = 1
      event-queue-arn     = "arn:aws:sqs:us-east-1:123456789012:event-queue-name"
      dlq-event-queue-arn = "arn:aws:sqs:us-east-1:123456789012:dlq-event-queue-name"
    }
  }
  schema-change-policy = {
    update-behavior = "UPDATE-IN-DATABASE"
    delete-behavior = "DELETE-FROM-DATABASE"
  }
  recrawl-policy = "CRAWL-EVERYTHING"
  glue-crawler-tags = {
    Purpose = "Crawl Sample data source."
  }
}
```

## Inputs

| Name                       | Description                                                           | Type        | Default            | Required |
| -------------------------- | --------------------------------------------------------------------- | ----------- | ------------------ | -------- |
| aws-region                 | The AWS region to deploy resources                                    | string      | "us-east-1"        | no       |
| glue-crawler-name          | The name of the Glue Crawler                                          | string      | n/a                | yes      |
| glue-crawler-role-arn      | The ARN of the IAM role that the Glue Crawler will use                | string      | n/a                | yes      |
| glue-crawler-database-name | The name of the database in which the crawler's output will be stored | string      | n/a                | yes      |
| glue-crawler-table-prefix  | The table prefix for the tables created by the crawler                | string      | n/a                | yes      |
| glue-crawler-description   | The description of the Glue Crawler                                   | string      | n/a                | no       |
| glue-crawler-configuration | The configuration for the Glue Crawler                                | string      | < see below >      | no       |
| glue-crawler-targets       | The targets for the Glue Crawler                                      | map(any)    | < see below >      | no       |
| schema-change-policy       | The schema change policy for the Glue Crawler                         | object      | < see below >      | no       |
| recrawl-policy             | The recrawl policy for the Glue Crawler                               | string      | "CRAWL-EVERYTHING" | no       |
| glue-crawler-tags          | Tags to assign to the Glue Crawler                                    | map(string) | {}                 | no       |

### glue-crawler-configuration object

| Name          | Description                              | Type   | Default       | Required |
| ------------- | ---------------------------------------- | ------ | ------------- | -------- |
| Version       | The version of the configuration         | number | 1.0           | no       |
| CrawlerOutput | The output configuration for the crawler | object | < see below > | no       |

### glue-crawler-targets object

| Name           | Description                                           | Type   | Default | Required |
| -------------- | ----------------------------------------------------- | ------ | ------- | -------- |
| s3-target      | The S3 target configuration for the Glue Crawler      | object | null    | no       |
| hudi-target    | The Hudi target configuration for the Glue Crawler    | object | null    | no       |
| mongodb-target | The MongoDB target configuration for the Glue Crawler | object | null    | no       |
| catalog-target | The catalog target configuration for the Glue Crawler | object | null    | no       |

### schema-change-policy object

| Name            | Description                                      | Type   | Default                | Required |
| --------------- | ------------------------------------------------ | ------ | ---------------------- | -------- |
| update-behavior | The update behavior for the schema change policy | string | "UPDATE-IN-DATABASE"   | no       |
| delete-behavior | The delete behavior for the schema change policy | string | "DELETE-FROM-DATABASE" | no       |

## Outputs

| Name                       | Description                                       |
| -------------------------- | ------------------------------------------------- |
| glue-crawler-id            | The ID of the Glue Crawler                        |
| glue-crawler-arn           | The ARN of the Glue Crawler                       |
| glue-crawler-name          | The name of the Glue Crawler                      |
| glue-crawler-role-arn      | The ARN of the IAM role used by the Glue Crawler  |
| glue-crawler-database-name | The name of the database used by the Glue Crawler |
| glue-crawler-table-prefix  | The table prefix used by the Glue Crawler         |
| glue-crawler-description   | The description of the Glue Crawler               |
| glue-crawler-configuration | The configuration of the Glue Crawler             |
| glue-crawler-targets       | The targets of the Glue Crawler                   |
| glue-crawler-tags          | The tags assigned to the Glue Crawler             |
| security-configuration-id  | The ID of the Glue Job Security Configuration     |


##### Code and documentation created with help of
![GitHub Copilot](https://img.shields.io/badge/github_copilot-8957E5?style=for-the-badge&logo=github-copilot&logoColor=white)&nbsp;![ChatGPT](https://img.shields.io/badge/chatGPT-74aa9c?style=for-the-badge&logo=openai&logoColor=white)