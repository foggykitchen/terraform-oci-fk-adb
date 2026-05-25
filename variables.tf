variable "compartment_ocid" {
  default = ""
}

variable "adb_password" {
  default = ""
}

variable "use_existing_vcn" {
  default = true
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_id" {
  default = ""
}

variable "adb_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "adb_subnet_id" {
  default = ""
}

variable "adb_nsg_id" {
  default = ""
}

variable "adb_free_tier" {
  default = false
}

variable "adb_private_endpoint" {
  default = true
}

variable "adb_database_cpu_core_count" {
  default = 1
}

variable "adb_database_data_storage_size_in_tbs" {
  default = 1
}

variable "adb_database_db_name" {
  default = "fkadb"
}

variable "adb_database_db_version" {
  default = "19c"
}

variable "adb_database_db_workload" {
  default = "OLTP"
}

variable "adb_data_safe_status" {
  default = "NOT_REGISTERED"
}

variable "adb_database_defined_tags_value" {
  default = ""
}

variable "adb_database_display_name" {
  default = "FoggyKitchenADB"
}

variable "adb_database_freeform_tags" {
  default = {
    "Owner" = "FoggyKitchen"
  }
}

variable "adb_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "adb_tde_wallet_zip_file" {
  default = "tde_wallet_fkadb.zip"
}

variable "adb_private_endpoint_label" {
  default = "fkadbpe"
}

variable "whitelisted_ips" {
  default = []
}

variable "is_auto_scaling_enabled" {
  default = false
}

variable "is_auto_scaling_for_storage_enabled" {
  default = false
}

variable "is_local_data_guard_enabled" {
  default = false
}

variable "adb_wallet_password_specials" {
  default = true
}

variable "adb_wallet_password_length" {
  default = 16
}

variable "adb_wallet_password_min_numeric" {
  default = 2
}

variable "adb_wallet_password_override_special" {
  default = ""
}

variable "defined_tags" {
  default = {}
}

variable "adb_backup_enabled" {
  default = false
}
variable "adb_backup_display_name" {
  default = "FoggyKitchenADB_Backup"
}

variable "adb_backup_is_long_term_backup" {
  default = true
}

variable "adb_backup_retention_period_in_days" {
  default = 90
}

variable "use_oci_vault" {
  default = false    
}
variable "vault_id" {
  default = ""
}

variable "kms_key_id" {
  default = ""
}

variable "source_type" {
  default = "NONE" # Options: NONE, DATABASE, CLONE_TO_REFRESHABLE, BACKUP_FROM_ID, BACKUP_FROM_TIMESTAMP, CROSS_REGION_DATAGUARD
}

variable "source_id" {
  default = ""
}

variable "clone_type" {
  default = "" # Options: FULL, METADATA
}

variable "refreshable_mode" {
  default = "" # Options: MANUAL vs AUTOMATIC
}

variable "remote_disaster_recovery_type" {
  default = ""  # Options: BACKUP_BASED, SNAPSHOT_STANDBY or ADG
}

variable "autonomous_database_backup_id" {
  default = ""    
}

variable "adb_compute_model" {
  default = "ECPU" # Options: null (cpuCoreCount > 0) vs ECPU (recommended) vs OCPU (legacy)
}

variable "adb_compute_count" {
  default = 2 # Options: 0 (cpu_core_count > 0) vs integer (min 2 when adb_compute_model = ECPU)
}



