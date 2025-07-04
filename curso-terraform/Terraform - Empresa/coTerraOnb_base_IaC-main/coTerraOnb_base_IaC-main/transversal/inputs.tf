#---------------------
# Global Variables
#---------------------
variable "country" {
  description = "Country of deployment."
  type        = string
  validation {
    condition     = contains(["co", "pa", "gt", "ts"], var.country)
    error_message = "The selected country is not valid; only 'co', 'pa', 'gt', and 'ts' are allowed."
  }
  nullable = false
}

variable "owner" {
  description = "Name of the area or team responsible for the application/project."
  type        = string
  nullable    = false
}

variable "bia" {
  description = "The component supports a BIA (Business Impact Analysis) service or process."
  type        = bool
  nullable    = false
}

variable "env" {
  description = "Environment where the component will be deployed. Its only possible values are: dev, qa, pdn, sbx, stg."
  type        = string
  validation {
    condition     = contains(["dev", "qa", "pdn", "sbx", "stg"], var.env)
    error_message = "The selected environment is not valid; only 'dev', 'qa', 'pdn', 'sbx', 'stg' are allowed."
  }
  nullable = false
}

variable "capacity" {
  description = "Name of the project being worked on."
  type        = string
  nullable    = false
}

variable "functionality" {
  description = "Name of the application being worked on."
  type        = string
  nullable    = false
}

variable "sox" {
  description = "Sarbanes-Oxley: Controls and security measures of the application."
  type        = bool
  nullable    = false
  default     = true
}

variable "confidentiality" {
  description = "Classification of the confidentiality of the data stored in this resource."
  type        = string
  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], var.confidentiality)
    error_message = "The confidentiality classification is not valid; only 'public', 'internal', 'confidential', or 'restricted' are allowed."
  }
  nullable = false
}

variable "integrity" {
  description = "Classification of the integrity of the data stored in this resource."
  type        = string
  validation {
    condition     = contains(["critical", "moderate", "tolerable", "low"], var.integrity)
    error_message = "The integrity classification is not valid; only 'critical', 'moderate', 'tolerable', or 'low' are allowed."
  }
  nullable = false
}

variable "availability" {
  description = "Classification of the availability of the data stored in this resource."
  type        = string
  validation {
    condition     = contains(["critical", "moderate", "tolerable", "low"], var.availability)
    error_message = "The availability classification is not valid; only 'critical', 'moderate', 'tolerable', or 'low' are allowed."
  }
  nullable = false
}

variable "map-migrated" {
  description = "Tags resources migrated for contract MAP."
  type        = string
  default     = "migYI61VXQDWG"
}

variable "tags" {
  description = "Additional tags to apply to the created resources."
  type        = map(string)
  default     = null
  nullable    = true
}
