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
  type        = string
  default     = ""
  description = "(Required) The name of this subnetwork, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with [RFC1035](https://datatracker.ietf.org/doc/html/rfc1035). Specifically, the name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "project_id" {
  type        = string
  default     = ""
  description = "Project id where the keyring will be created."
}

variable "location" {
  type        = string
  default     = ""
  description = "Location for the keyring."
}

variable "keyring" {
  type        = string
  default     = ""
  description = "Keyring name."
}

variable "keys" {
  type        = list(string)
  default     = []
  description = "Key names."
}

variable "prevent_destroy" {
  type        = bool
  default     = true
  description = "Set the prevent_destroy lifecycle attribute on keys."
}

variable "purpose" {
  type        = string
  default     = "ENCRYPT_DECRYPT"
  description = "The immutable purpose of the CryptoKey. Possible values are ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, and ASYMMETRIC_DECRYPT."
}

variable "set_owners_for" {
  type        = list(string)
  default     = []
  description = "Name of keys for which owners will be set."
}

variable "service_accounts" {
  type        = list(string)
  default     = []
  description = "List of comma-separated owners for each key declared in set_owners_for."
}

variable "set_encrypters_for" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  type        = list(string)
  default     = []
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
}

variable "set_decrypters_for" {
  type        = list(string)
  default     = []
  description = "Name of keys for which decrypters will be set."
}

variable "decrypters" {
  type        = list(string)
  default     = []
  description = "List of comma-separated owners for each key declared in set_decrypters_for."
}

variable "key_rotation_period" {
  type    = string
  default = "100000s"
}

variable "key_algorithm" {
  type        = string
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
}

variable "key_protection_level" {
  type        = string
  default     = "SOFTWARE"
  description = "The protection level to use when creating a version based on this template. Default value: \"SOFTWARE\" Possible values: [\"SOFTWARE\", \"HSM\"]"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels, provided as a map"
}

variable "role" {
  type        = string
  default     = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  description = "this role use for permissions"
}
