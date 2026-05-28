locals {
  adb_nsg_id    = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_network_security_group.fk_adb_nsg[0].id : var.adb_nsg_id
  adb_subnet_id = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_subnet.fk_adb_subnet[0].id : var.adb_subnet_id
}

resource "oci_database_autonomous_database" "fk_adb_database" {
  admin_password                      = var.adb_password
  vault_id                            = var.use_oci_vault ? var.vault_id : null
  kms_key_id                          = var.use_oci_vault ? var.kms_key_id : null
  compartment_id                      = var.compartment_ocid
  cpu_core_count                      = var.adb_compute_model == "ECPU" ? null : var.adb_database_cpu_core_count
  data_storage_size_in_tbs            = var.adb_database_data_storage_size_in_tbs
  db_name                             = var.adb_database_db_name
  db_version                          = var.adb_database_db_version
  data_safe_status                    = var.adb_data_safe_status
  db_workload                         = var.adb_database_db_workload
  display_name                        = var.adb_database_display_name
  freeform_tags                       = var.adb_database_freeform_tags
  license_model                       = var.adb_database_license_model
  is_free_tier                        = var.adb_free_tier
  is_auto_scaling_enabled             = var.is_auto_scaling_enabled
  is_auto_scaling_for_storage_enabled = var.is_auto_scaling_for_storage_enabled 
  is_local_data_guard_enabled         = var.is_local_data_guard_enabled
  whitelisted_ips                     = var.adb_private_endpoint ? null : var.whitelisted_ips
  nsg_ids                             = var.adb_private_endpoint ? [local.adb_nsg_id] : null
  private_endpoint_label              = var.adb_private_endpoint ? var.adb_private_endpoint_label : null
  subnet_id                           = var.adb_private_endpoint ? local.adb_subnet_id : null
  defined_tags                        = var.defined_tags
  source                              = var.source_type
  source_id                           = var.source_id
  clone_type                          = var.clone_type
  refreshable_mode                    = var.refreshable_mode          
  remote_disaster_recovery_type       = var.remote_disaster_recovery_type
  autonomous_database_backup_id       = var.autonomous_database_backup_id
  compute_model                       = var.adb_compute_model
  compute_count                       = var.adb_compute_model == "ECPU" ? var.adb_compute_count : null       

  # OCI Always Free ECPU databases may be created only with a higher requested
  # compute_count, but then report an effective count of 1 on refresh. Ignore
  # this provider drift so retrying apply after partial failures remains possible.
  lifecycle {
    ignore_changes = [compute_count]
  }
}

resource "random_password" "wallet_password" {
  length           = var.adb_wallet_password_length
  special          = var.adb_wallet_password_specials
  min_numeric      = var.adb_wallet_password_min_numeric
  override_special = var.adb_wallet_password_override_special
}

resource "oci_database_autonomous_database_wallet" "fk_adb_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.fk_adb_database.id
  password               = random_password.wallet_password.result
  base64_encode_content  = "true"
}

resource "oci_database_autonomous_database_backup" "fk_adb_database_backup" {
    count                    = var.adb_backup_enabled ? 1 : 0
    autonomous_database_id   = oci_database_autonomous_database.fk_adb_database.id
    display_name             = var.adb_backup_display_name
    is_long_term_backup      = var.adb_backup_is_long_term_backup
    retention_period_in_days = var.adb_backup_retention_period_in_days
}
