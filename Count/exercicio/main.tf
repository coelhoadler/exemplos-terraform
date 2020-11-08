provider "aws" {
  region = "us-east-1"
}

resource "aws_sqs_queue" "terraform_queue" {
  name = "${format("sqs-%03d", count.index + 1)}"

  tags = {
    Environment = "production"
  }
  
  count = 5
}
