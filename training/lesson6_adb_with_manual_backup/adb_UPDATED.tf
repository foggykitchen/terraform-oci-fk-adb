module "oci-fk-adb" {
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADB"
  adb_database_display_name             = "FoggyKitchenADB"
  adb_password                          = var.adb_password
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  use_existing_vcn                      = true
  adb_private_endpoint                  = true
  adb_subnet_id                         = module.fk_vcn.subnet_ids["adb_private"]
  adb_nsg_id                            = module.fk_nsg.nsg_id
  adb_backup_enabled                    = var.adb_backup_enabled
}

module "oci-fk-adb-clone-from-backup" {
  count                                 = var.adb_clone_from_backup ? 1 : 0
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADB2"
  adb_database_display_name             = "FoggyKitchenADB_CloneFromBackup"
  adb_password                          = var.adb_password
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  adb_private_endpoint                  = true
  adb_private_endpoint_label            = "fkadbpe3"
  use_existing_vcn                      = true
  vcn_id                                = module.fk_vcn.vcn_id
  adb_subnet_id                         = module.fk_vcn.subnet_ids["adb_private"]
  adb_nsg_id                            = module.fk_nsg.nsg_id
  clone_type                            = "FULL"
  source_type                           = "BACKUP_FROM_ID"
  autonomous_database_backup_id         = module.oci-fk-adb.adb_database_backup.adb_database_backup_id[0]
}
