module "oci-fk-adb" {
  source                                = "../.."
  adb_database_db_name                  = "FoggyKitchenFreeTierADB"
  adb_database_display_name             = "FoggyKitchenFreeTierADB"
  adb_password                          = var.adb_password
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = true
  adb_database_cpu_core_count           = 1
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  use_existing_vcn                      = false
  adb_private_endpoint                  = false
  whitelisted_ips                       = [var.my_public_ip]
}
