provider "aws" {

  access_key = "dummy"
  secret_key = "dummy"
  region     = "us-east-1"

  s3_use_path_style = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    sqs = "http://localstack:4566"
    s3  = "http://localstack:4566"
  }
}

resource "aws_s3_bucket" "image_uploader" {
  bucket = "image-uploader"
}

resource "aws_sqs_queue" "upload_image_successfully" {
  name = "upload-image-successfully"
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "arn:aws:sqs:*:*:upload-image-successfully",
        "Condition": {
          "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.image_uploader.arn}" }
        }
      }
    ]
  }
  POLICY
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_uploader.id

  queue {
    queue_arn     = aws_sqs_queue.upload_image_successfully.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}