resource "aws_sqs_queue" "my_queue" {
  name                              = "poc-sqs"
  kms_master_key_id                 = aws_kms_key.custom_kms.arn
  kms_data_key_reuse_period_seconds = 300
}

data "aws_iam_policy_document" "sns_sqs_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.my_queue.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.my_topic.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sns_policy" {
  queue_url = aws_sqs_queue.my_queue.id
  policy    = data.aws_iam_policy_document.sns_sqs_policy.json
}
