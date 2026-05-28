output "adb_database" {
  value = {
    adb_database_id     = oci_database_autonomous_database.fk_adb_database.id
    connection_urls     = oci_database_autonomous_database.fk_adb_database.connection_urls
    adb_wallet_content  = oci_database_autonomous_database_wallet.fk_adb_database_wallet.content
    adb_wallet_password = random_password.wallet_password.result
    adb_nsg_id          = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_network_security_group.fk_adb_nsg[0].id : var.adb_nsg_id
    private_endpoint_ip = var.adb_private_endpoint ? join(",", oci_database_autonomous_database.fk_adb_database[*].private_endpoint_ip) : ""
  }
}

output "adb_database_backup" {
   value = {
     adb_database_id          = var.adb_backup_enabled ? oci_database_autonomous_database_backup.fk_adb_database_backup[*].autonomous_database_id : null
     adb_database_backup_id   = var.adb_backup_enabled ? oci_database_autonomous_database_backup.fk_adb_database_backup[*].id : null
     adb_database_backup_type = var.adb_backup_enabled ? oci_database_autonomous_database_backup.fk_adb_database_backup[*].type : null
   } 
}

output "adb_database_network" {
   value = {
     adb_database_vcn_id      = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_vcn.fk_adb_vcn[*].id : null
     adb_database_subnet_id   = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_subnet.fk_adb_subnet[*].id : null
     adb_database_nsg         = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_network_security_group.fk_adb_nsg[*].id : null
   } 
}
