# README

Terraform module to create a bash-based runtime for quick execution of scripts via Lambda.

Use this module to create the runtime, and then use the usual methods of creating a Lambda, specifying the resulting Layer and runtime `provided.al2`.

You can set environment variables statically, as usual. In addition, any key/value pair in the passed event data will also be made avaiable as environment variables.

## Usage

```hcl
module "shell_runtime" {
  source  = "tecracer-theinen/terraform-aws-shell-runtime"
  version = "0.1.0"
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.18.0"

  function_name = "get-weather"
  description   = "Get weather for given city name"
  handler       = "function.handler"
  publish       = true
  timeout       = 10

  # Use the shell runtime
  layers        = [module.shell_runtime.runtime_arn]
  runtime       = "provided.al2"

  source_path = [{
    path     = "src/lambda/"
  }]
}
```

### Handler Example

`src/lambda/function.sh`:

```bash
function handler () {
  curl --silent https://wttr.in/$CITY?format=j1
}
```

### Event Example

```json
{
  "CITY": "Accra"
}
```

## Response Objects

Any output from STDOUT will be passed as response, along with the command's exit code.

Example output:

```json
{
  "exit": 0,
  "stdout": "Accra: ⛅️  +31°C"
}
```

In case of commands which return JSON, you can switch between escaping the response as text, or returning JSON instead via setting the `JSON_RETURN` environment variable to any value.

Example output:

```json
{
  "exit": 0,
  "stdout": {
    "current_condition": [
      {
        "temp_C": "31",
        "cloudcover": "50",
        "humidity": "71"
      }
    ],
    "nearest_area": [
      {
        "areaName": [
          {
            "value": "Accra"
          }
        ]
      }
    ]
  }
}
```

## Custom Layer Initialization

Sometimes you want to add files to your custom runtime. While you cannot use package installers like `rpm` or `yum`, you can copy files and unpacked RPM packages to the runtime.

This example using the `initialization` input will download a Amazon Linux 2 RPM and move its contents into the runtime. The working directory for this is automatically set to the root of the custom runtime (`/opt` when deployed)

```hcl
module "shell_runtime" {
  source  = "tecracer-theinen/terraform-aws-shell-runtime"
  version = "0.1.0"

  initialization = <<SCRIPT
    wget --quiet https://s3.amazonaws.com/cloudhsmv2-software/CloudHsmClient/EL7/cloudhsm-cli-latest.el7.x86_64.rpm
    rpm2cpio cloudhsm-cli-latest.el7.x86_64.rpm | cpio -idmv
    mv ./opt/cloudhsm .
    rmdir opt
  SCRIPT
}
```

As these actions get executed locally, you will need the used tools installed (here: `rpm2cpio` and `cpio`)
