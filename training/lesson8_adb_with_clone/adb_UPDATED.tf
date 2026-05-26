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

module "oci-fk-adb-clone" {
  count                                 = var.adb_full_clone_enabled ? 1 : 0
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenADBFullClone"
  adb_database_display_name             = "FoggyKitchenADB_FullClone"
  adb_password                          = var.adb_password
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  adb_private_endpoint                  = true
  adb_private_endpoint_label            = "fkadbpefc"
  use_existing_vcn                      = true
  vcn_id                                = module.fk_vcn.vcn_id
  adb_subnet_id                         = module.fk_vcn.subnet_ids["adb_private"]
  adb_nsg_id                            = module.fk_nsg.nsg_id
  source_type                           = "DATABASE"
  source_id                             = module.oci-fk-adb-source.adb_database.adb_database_id
  clone_type                            = "FULL"
}


