module "oci-fk-adb-source" {
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADBSource"
  adb_database_display_name             = "FoggyKitchenADB_Source"
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
}

module "oci-fk-adb-refreshable-clone" {
  count                                 = var.adb_refreshable_clone_enabled ? 1 : 0
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADBRefClone"
  adb_database_display_name             = "FoggyKitchenADB_RefreshableClone"
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  use_existing_vcn                      = true
  vcn_id                                = module.fk_vcn.vcn_id
  adb_subnet_id                         = module.fk_vcn.subnet_ids["adb_private"]
  adb_nsg_id                            = module.fk_nsg.nsg_id
  adb_private_endpoint                  = true
  adb_private_endpoint_label            = "fkadbperc"
  source_type                           = "CLONE_TO_REFRESHABLE"
  source_id                             = module.oci-fk-adb-source.adb_database.adb_database_id
  refreshable_mode                      = var.adb_refreshable_mode
}


