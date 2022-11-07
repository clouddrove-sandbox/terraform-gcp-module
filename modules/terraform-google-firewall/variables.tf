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

variable "name" {
  type    = string
  default = ""
}

variable "network" {
  type    = string
  default = ""
}

variable "protocol" {
  type        = string
  default     = ""
  description = "The name of the protocol to allow"
}

variable "ports" {
  type    = list(any)
  default = []
}

variable "source_ranges" {
  type    = list(any)
  default = []
}