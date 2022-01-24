variable "name" {
  description = "The name wich should be used for this Subscription Template Deployment"
  type        = string
}

variable "location" {
  description = "The Azure Region where the Subscription Template Deployment should exist"
  type        = string
}

variable "parameters_content" {
  description = "The contents of the ARM Template paramters file - containing a JSON list of parameters."
  type        = string
}

variable "template_content" {
  description = "The contents of the ARM Template which should be deployed into this Subscription"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
