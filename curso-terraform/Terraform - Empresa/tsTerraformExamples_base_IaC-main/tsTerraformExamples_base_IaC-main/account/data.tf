# data "aws_iam_policy_document" "only_ssl" {
#   provider = aws.main

#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = [var.account_id]
#     }

#     actions = [
#       "s3:*"
#     ]

#     effect = "Deny"

#     resources = [
#       module.s3.bucket_arn,
#       "${module.s3.bucket_arn}/*",
#     ]
#     condition {
#       test     = "Bool"
#       variable = "aws:SecureTransport"
#       values = [
#         "false"
#       ]
#     }
#   }
# }