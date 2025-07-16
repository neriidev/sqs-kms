resource "aws_kms_key" "custom_kms" {
  description         = "Chave KMS para SQS"
  deletion_window_in_days = 7
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid    = "AllowRootAccountFullAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "AllowSNSUsage",
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "custom_kms_alias" {
  name          = "alias/sqs-key"
  target_key_id = aws_kms_key.custom_kms.key_id
}