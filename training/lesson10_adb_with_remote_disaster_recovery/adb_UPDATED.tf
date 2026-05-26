module "oci-fk-adb-primary" {
  providers = {
    oci = oci.primary
  }
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADB"
  adb_database_display_name             = "FoggyKitchenADB_Source"
  adb_password                          = var.adb_password
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  use_existing_vcn                      = true
  adb_private_endpoint                  = true
  adb_subnet_id                         = module.vcn_primary.subnet_ids["adb_private"]
  adb_nsg_id                            = module.nsg_primary.nsg_id
}

module "oci-fk-adb-remote-standby" {
  providers = {
    oci = oci.standby
  }
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADB"
  adb_database_display_name             = "FoggyKitchenADB_Standby"
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  use_existing_vcn                      = true
  adb_private_endpoint                  = true
  adb_private_endpoint_label            = "fkadbpes"
  adb_subnet_id                         = module.vcn_standby.subnet_ids["adb_private"]
  adb_nsg_id                            = module.nsg_standby.nsg_id
  source_id                             = module.oci-fk-adb-primary.adb_database.adb_database_id
  source_type                           = "CROSS_REGION_DISASTER_RECOVERY"
  remote_disaster_recovery_type         = "BACKUP_BASED"
}


