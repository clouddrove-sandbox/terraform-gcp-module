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

variable "owners" {
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