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
  is_local_data_guard_enabled           = true
}
