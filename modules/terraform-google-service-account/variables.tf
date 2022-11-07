variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "project" {
  description = "The name of the GCP Project where all resources will be launched."
  type        = string
}

variable "name" {
  type    = string
  default = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "description" {
  description = "The description of the custom service account."
  type        = string
  default     = ""
}

variable "service_account_roles" {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = []
}

variable "all_service_account_roles" {
  type        = list(any)
  description = ""
  default     = []
}

variable "upper" {
  type    = bool
  default = false
}

variable "special" {
  type    = bool
  default = false
}

variable "length" {
  type    = number
  default = 1
}