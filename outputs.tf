output "runtime_arn" {
  description = "Lambda Layer ARN to use for custom runtime."
  value       = aws_lambda_layer_version.shell.arn
}
