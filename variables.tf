variable "compartment_ocid" {
  description = "Compartment OCID where Autonomous Database resources will be created."
  type        = string
}

variable "adb_password" {
  description = "Administrator password for the Autonomous Database."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.adb_password) >= 12 && length(var.adb_password) <= 30
    error_message = "adb_password must be between 12 and 30 characters."
  }
}

variable "use_existing_vcn" {
  description = "Reuse an existing VCN, subnet, and NSG for private endpoint deployments instead of creating raw networking resources in this module."
  type        = bool
  default     = true
}

variable "vcn_cidr" {
  description = "VCN CIDR used only when adb_private_endpoint is true and use_existing_vcn is false."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vcn_id" {
  description = "Existing VCN OCID for private endpoint deployments. Reserved for external composition patterns."
  type        = string
  default     = null
}

variable "adb_subnet_cidr" {
  description = "Subnet CIDR used only when adb_private_endpoint is true and use_existing_vcn is false."
  type        = string
  default     = "10.0.1.0/24"
}

variable "adb_subnet_id" {
  description = "Existing subnet OCID used for private endpoint deployments when use_existing_vcn is true."
  type        = string
  default     = null
}

variable "adb_nsg_id" {
  description = "Existing NSG OCID used for private endpoint deployments when use_existing_vcn is true."
  type        = string
  default     = null
}

variable "adb_free_tier" {
  description = "Deploy the Autonomous Database using a Free Tier shape when supported."
  type        = bool
  default     = false
}

variable "adb_private_endpoint" {
  description = "Enable private endpoint deployment for the Autonomous Database."
  type        = bool
  default     = true
}

variable "adb_database_cpu_core_count" {
  description = "CPU core count used when adb_compute_model is not set to ECPU."
  type        = number
  default     = 1
}

variable "adb_database_data_storage_size_in_tbs" {
  description = "Allocated Autonomous Database storage size in TB."
  type        = number
  default     = 1
}

variable "adb_database_db_name" {
  description = "Database name for the Autonomous Database."
  type        = string
  default     = "fkadb"
}

variable "adb_database_db_version" {
  description = "Autonomous Database engine version."
  type        = string
  default     = "19c"
}

variable "adb_database_db_workload" {
  description = "Database workload type, typically OLTP or DW."
  type        = string
  default     = "OLTP"

  validation {
    condition     = contains(["OLTP", "DW", "AJD", "APEX"], var.adb_database_db_workload)
    error_message = "adb_database_db_workload must be one of: OLTP, DW, AJD, APEX."
  }
}

variable "adb_data_safe_status" {
  description = "OCI Data Safe registration status for the Autonomous Database."
  type        = string
  default     = "NOT_REGISTERED"

  validation {
    condition     = contains(["REGISTERED", "NOT_REGISTERED"], var.adb_data_safe_status)
    error_message = "adb_data_safe_status must be either REGISTERED or NOT_REGISTERED."
  }
}

variable "adb_database_defined_tags_value" {
  description = "Deprecated legacy variable kept for backward compatibility. It is currently unused by the module."
  type        = string
  default     = null
}

variable "adb_database_display_name" {
  description = "Display name for the Autonomous Database."
  type        = string
  default     = "FoggyKitchenADB"
}

variable "adb_database_freeform_tags" {
  description = "Freeform tags applied to the Autonomous Database resource."
  type        = map(string)
  default = {
    Owner = "FoggyKitchen"
  }
}

variable "adb_database_license_model" {
  description = "License model for the Autonomous Database."
  type        = string
  default     = "LICENSE_INCLUDED"

  validation {
    condition     = contains(["LICENSE_INCLUDED", "BRING_YOUR_OWN_LICENSE"], var.adb_database_license_model)
    error_message = "adb_database_license_model must be either LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE."
  }
}

variable "adb_tde_wallet_zip_file" {
  description = "Deprecated legacy variable kept for backward compatibility. It is currently unused by the module."
  type        = string
  default     = "tde_wallet_fkadb.zip"
}

variable "adb_private_endpoint_label" {
  description = "Private endpoint label used when adb_private_endpoint is enabled."
  type        = string
  default     = "fkadbpe"
}

variable "whitelisted_ips" {
  description = "Public IP allowlist applied only when adb_private_endpoint is false."
  type        = list(string)
  default     = []
}

variable "is_auto_scaling_enabled" {
  description = "Enable Autonomous Database compute autoscaling."
  type        = bool
  default     = false
}

variable "is_auto_scaling_for_storage_enabled" {
  description = "Enable Autonomous Database storage autoscaling."
  type        = bool
  default     = false
}

variable "is_local_data_guard_enabled" {
  description = "Enable Local Autonomous Data Guard for the Autonomous Database."
  type        = bool
  default     = false
}

variable "adb_wallet_password_specials" {
  description = "Allow special characters in the generated wallet password."
  type        = bool
  default     = true
}

variable "adb_wallet_password_length" {
  description = "Length of the generated wallet password."
  type        = number
  default     = 16
}

variable "adb_wallet_password_min_numeric" {
  description = "Minimum number of numeric characters in the generated wallet password."
  type        = number
  default     = 2
}

variable "adb_wallet_password_override_special" {
  description = "Override string for special characters used by the generated wallet password."
  type        = string
  default     = ""
}

variable "defined_tags" {
  description = "Defined tags applied to resources created by this module."
  type        = map(string)
  default     = {}
}

variable "adb_backup_enabled" {
  description = "Create a manual Autonomous Database backup after database provisioning."
  type        = bool
  default     = false
}

variable "adb_backup_display_name" {
  description = "Display name for the optional manual Autonomous Database backup."
  type        = string
  default     = "FoggyKitchenADB_Backup"
}

variable "adb_backup_is_long_term_backup" {
  description = "Create the optional backup as a long-term backup."
  type        = bool
  default     = true
}

variable "adb_backup_retention_period_in_days" {
  description = "Retention period in days for the optional manual backup."
  type        = number
  default     = 90
}

variable "use_oci_vault" {
  description = "Enable OCI Vault integration for customer-managed encryption keys."
  type        = bool
  default     = false
}

variable "vault_id" {
  description = "Existing OCI Vault OCID used when use_oci_vault is true."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Existing OCI KMS key OCID used when use_oci_vault is true."
  type        = string
  default     = null
}

variable "source_type" {
  description = "Source mode for clone or disaster recovery workflows."
  type        = string
  default     = "NONE"

  validation {
    condition = contains([
      "NONE",
      "DATABASE",
      "CLONE_TO_REFRESHABLE",
      "BACKUP_FROM_ID",
      "BACKUP_FROM_TIMESTAMP",
      "CROSS_REGION_DISASTER_RECOVERY",
    ], var.source_type)
    error_message = "source_type must be one of: NONE, DATABASE, CLONE_TO_REFRESHABLE, BACKUP_FROM_ID, BACKUP_FROM_TIMESTAMP, CROSS_REGION_DISASTER_RECOVERY."
  }
}

variable "source_id" {
  description = "Source Autonomous Database OCID used by clone or disaster recovery workflows."
  type        = string
  default     = null
}

variable "clone_type" {
  description = "Clone type used when source_type represents a clone workflow."
  type        = string
  default     = null

  validation {
    condition     = var.clone_type == null || contains(["FULL", "METADATA"], var.clone_type)
    error_message = "clone_type must be null, FULL, or METADATA."
  }
}

variable "refreshable_mode" {
  description = "Refresh mode for refreshable clones."
  type        = string
  default     = null

  validation {
    condition     = var.refreshable_mode == null || contains(["MANUAL", "AUTOMATIC"], var.refreshable_mode)
    error_message = "refreshable_mode must be null, MANUAL, or AUTOMATIC."
  }
}

variable "remote_disaster_recovery_type" {
  description = "Remote disaster recovery type for cross-region standby workflows."
  type        = string
  default     = null

  validation {
    condition     = var.remote_disaster_recovery_type == null || contains(["BACKUP_BASED", "SNAPSHOT_STANDBY", "ADG"], var.remote_disaster_recovery_type)
    error_message = "remote_disaster_recovery_type must be null, BACKUP_BASED, SNAPSHOT_STANDBY, or ADG."
  }
}

variable "autonomous_database_backup_id" {
  description = "Existing Autonomous Database backup OCID used for backup-based restore or clone scenarios."
  type        = string
  default     = null
}

variable "adb_compute_model" {
  description = "Autonomous Database compute model."
  type        = string
  default     = "ECPU"

  validation {
    condition     = contains(["ECPU", "OCPU"], var.adb_compute_model)
    error_message = "adb_compute_model must be either ECPU or OCPU."
  }
}

variable "adb_compute_count" {
  description = "Compute count used when adb_compute_model is set to ECPU."
  type        = number
  default     = 2
}
