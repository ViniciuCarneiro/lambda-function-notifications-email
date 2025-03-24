{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
        "Resource": "arn:aws:sqs:${aws_region}:${aws_account_id}:${sqs_queue_name}"
      }
    ]
  }
  