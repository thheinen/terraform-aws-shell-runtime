locals {
  jq_version = "1.6"
}

resource "terraform_data" "download_jq_unix" {
  count = local.os == "Windows" ? 0 : 1

  provisioner "local-exec" {
    when    = create
    quiet   = "true"
    command = <<CMD
      curl --location-trusted https://github.com/stedolan/jq/releases/download/jq-${local.jq_version}/jq-linux64 \
           --output ${path.root}/src/custom_runtime/bin/jq --silent
    CMD
  }
}

resource "terraform_data" "download_jq_windows" {
  count = local.os == "Windows" ? 1 : 0

  provisioner "local-exec" {
    when    = create
    quiet   = "true"
    command = <<CMD
      Invoke-WebRequest -Uri https://github.com/stedolan/jq/releases/download/jq-${local.jq_version}/jq-linux64 -OutFile ${path.root}/src/custom_runtime/bin/jq
    CMD
  }
}
