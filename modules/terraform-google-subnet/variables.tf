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

variable "network" {
  type    = string
  default = ""
}

variable "name" {
  type        = string
  default     = ""
  description = "(Required) The name of this subnetwork, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with [RFC1035](https://datatracker.ietf.org/doc/html/rfc1035). Specifically, the name must be 1-63 characters long and match the regular expression `[a-z]([-a-z0-9]*[a-z0-9])?` which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
}

variable "region" {
  type        = string
  default     = "europe-west3"
  description = "(Required) The GCP region for this subnetwork."
}

variable "ip_cidr_range" {
  type        = string
  default     = "10.2.0.0/16"
  description = "(Required) The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "private_ip_google_access" {
  type        = bool
  description = "(Optional) When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access."
  default     = true
}

variable "description" {
  type        = string
  description = "(Optional) An optional description of this subnetwork. Provide this property when you create the resource. This field can be set only at resource creation time."
  default     = null
}

variable "secondary_ip_ranges" {
  type        = any
  description = "An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges."
  default     = []
}

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resources belong. If it is not set, the provider project is used."
  default     = null
}

variable "log_config" {
  type        = list(any)
  description = "(Optional) Logging options for the subnetwork flow logs. Setting this value to 'null' will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples."
  default     = []
}

variable "allow" {
  type        = list(any)
  description = "(Optional) The list of ALLOW rules specified by this firewall. Each rule specifies a protocol and port-range tuple that describes a permitted connection."
  default     = []
}

## IAM

variable "iam" {
  description = "(Optional) A list of IAM access."
  type        = any
  default     = []

  # validate required keys in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setintersection(keys(x), ["role", "members"])) == 2])
    error_message = "Each object in var.iam must specify a role and a set of members."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setsubtract(keys(x), ["role", "members", "authoritative"])) == 0])
    error_message = "Each object in var.iam does only support role, members and authoritative attributes."
  }
}

variable "policy_bindings" {
  description = "(Optional) A list of IAM policy bindings."
  type        = any
  default     = null

  # validate required keys in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setintersection(keys(x), ["role", "members"])) == 2])
    error_message = "Each object in var.policy_bindings must specify a role and a set of members."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setsubtract(keys(x), ["role", "members", "condition"])) == 0])
    error_message = "Each object in var.policy_bindings does only support role, members and condition attributes."
  }
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

variable "module_timeouts" {
  type        = any
  description = "(Optional) How long certain operations (per resource type) are allowed to take before being considered to have failed."
  default     = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}

variable "address_type" {
  type        = string
  description = "(Optional) The type of the address to reserve."
  default     = "EXTERNAL"
}

variable "purpose" {
  type        = string
  description = "(Optional) The purpose of the resource."
  default     = "VPC_PEERING"
}

variable "prefix_length" {
  type        = number
  description = "(Optional) The prefix length of the IP range."
  default     = 16
}

variable "private_service_connect_ip" {
  type        = string
  description = "(Optional) The IP address or beginning of the address range represented by this resource."
  default     = ""
}

variable "source_ranges" {
  type        = any
  description = "(Optional) If source ranges are specified, the firewall will apply only to traffic that has source IP address in these ranges."
  default     = []
}

variable "asn" {
  type        = number
  description = "Local BGP Autonomous System Number (ASN). Must be an RFC6996 private ASN, either 16-bit or 32-bit."
  default     = 64514
}

variable "nat_ip_allocate_option" {
  type        = string
  description = "How external IPs should be allocated for this NAT."
  default     = "MANUAL_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  description = "How NAT should be configured per Subnetwork."
  default     = ""
}

variable "filter" {
  type        = string
  description = "Specifies the desired filtering of logs on this NAT."
  default     = ""
}

variable "dest_range" {
  type        = string
  description = "The destination range of outgoing packets that this route applies to. Only IPv4 is supported."
  default     = "0.0.0.0/0"
}

variable "next_hop_gateway" {
  type        = string
  description = "URL to a gateway that should handle matching packets."
  default     = ""
}

variable "priority" {
  type        = number
  description = "The priority of this route."
  default     = 1000
}