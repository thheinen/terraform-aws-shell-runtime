# From https://www.tecracer.com/blog/2021/05/terraform-os-detection.html
data "external" "os" {
  working_dir = path.module
  program     = ["printf", "{\"os\": \"Linux\"}"]
}

locals {
  os = data.external.os.result.os
}
