# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "bucket_name_1" {
  length    = 5
  separator = "-"
}

resource "random_pet" "bucket_name_2" {
  length    = 5
  separator = "-"
}

locals {
  bucket_names = {
    bucket_1 = random_pet.bucket_name_1.id
    bucket_2 = random_pet.bucket_name_2.id
  }
}

resource "aws_s3_bucket" "sample" {
  for_each = local.bucket_names

  bucket = each.value
  tags = {
    public_bucket = false
  }
}
