
output "sqs_queue_url" {
  value = aws_sqs_queue.my_queue.id
}

output "lambda_function_name" {
  value = aws_lambda_function.sqs_listener.function_name
}
