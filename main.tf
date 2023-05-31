resource "null_resource" "initialize" {
  provisioner "local-exec" {
    working_dir = "src/custom_runtime/"
    command     = var.initialization
  }
}

resource "local_file" "add" {
  for_each = var.opt_files

  filename = "src/custom_runtime/${each.key}"
  content  = each.value
}

data "archive_file" "runtime" {
  type        = "zip"
  source_dir  = "src/custom_runtime/"
  output_path = "builds/runtime.zip"

  depends_on = [
    null_resource.initialize,
    local_file.add[0],
    terraform_data.download_jq_unix,
    terraform_data.download_jq_windows
  ]
}

resource "aws_lambda_layer_version" "shell" {
  filename   = "builds/runtime.zip"
  layer_name = "shell_runtime"

  compatible_runtimes = ["provided.al2"]
  source_code_hash    = data.archive_file.runtime.output_base64sha256
}
