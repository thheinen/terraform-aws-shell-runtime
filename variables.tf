variable "initialization" {
  description = "Instructions to execute before baking Lambda layer (OS-dependent)"
  default     = ""
  type        = string
}

variable "opt_files" {
  description = "Files and contents to add (relative to /opt)"
  default     = {}
  type        = map(string)
}
