# terraform-oci-fk-adb

This repository contains a reusable **Terraform / OpenTofu module** and progressive training examples for deploying **Oracle Autonomous Database Serverless (ADB-S)** on **Oracle Cloud Infrastructure (OCI)**.

It is part of the [FoggyKitchen.com](https://foggykitchen.com) training ecosystem and is designed as a composable ADB layer that can be combined with networking, Vault, disaster recovery, cloning, and backup scenarios.

---

## Purpose

The goal of this module is to provide a clear, reusable reference implementation for Autonomous Database Serverless:

- Autonomous Database Serverless provisioning
- Free Tier and paid deployment paths
- Public endpoint deployments with IP allowlists
- Private endpoint deployments with optional module-managed networking
- Optional manual backup creation
- Optional OCI Vault integration for customer-managed encryption keys
- Clone and refreshable clone scenarios
- Local and remote disaster recovery scenarios
- OCPU and ECPU compute model support

This is not a full landing zone module. Networking, encryption, and recovery settings stay explicit so the module can be reused in different training and project scenarios.

---

## What the module does

Depending on the configuration, the module can create:

- Autonomous Database Serverless
- Database wallet
- Optional manual backup
- Optional VCN for private endpoint deployments
- Optional service gateway, NAT gateway, route table, subnet, and NSG for private endpoint deployments

The module intentionally does not create:

- Bastion hosts
- OCI Vault resources themselves
- Application schemas or data model objects
- Data migration workflows
- Cross-module IAM or policy scaffolding

Those concerns belong in dedicated modules or lesson-specific examples.

---

## Repository Structure

```bash
terraform-oci-fk-adb/
├── README.md
├── LICENSE
├── provider.tf
├── datasources.tf
├── network.tf
├── adb.tf
├── outputs.tf
├── variables.tf
└── training/
    ├── README.md
    ├── lesson1_free_tier_adb/
    ├── lesson2_free_tier_adb_with_ip_whitelisting/
    ├── lesson3_adb_with_private_endpoint/
    ├── lesson4_adb_with_local_disaster_recovery/
    ├── lesson5_adb_with_local_data_guard/
    ├── lesson6_adb_with_manual_backup/
    ├── lesson7_adb_with_oci_vault/
    ├── lesson8_adb_with_clone/
    ├── lesson9_adb_with_refreshable_clone/
    ├── lesson10_adb_with_remote_disaster_recovery/
    ├── lesson11_adb_with_remote_data_guard/
    └── lesson12_adb_with_ecpu_compute_model/
```

Each lesson folder is runnable on its own and focuses on a narrower ADB scenario built on the same module foundation.

---

## Example Usage

```hcl
module "adb" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-adb.git"

  compartment_ocid                = var.compartment_ocid
  adb_password                    = var.adb_password
  adb_database_db_name            = "fkadb"
  adb_database_display_name       = "FoggyKitchenADB"
  adb_database_db_workload        = "OLTP"
  adb_compute_model               = "ECPU"
  adb_compute_count               = 2
  adb_database_data_storage_size_in_tbs = 1

  adb_private_endpoint            = true
  use_existing_vcn                = false
  vcn_cidr                        = "10.0.0.0/16"
  adb_subnet_cidr                 = "10.0.1.0/24"

  is_auto_scaling_enabled         = true
  is_auto_scaling_for_storage_enabled = true
  adb_backup_enabled              = false
}
```

---

## Inputs

Key inputs exposed by the module:

- `compartment_ocid`: compartment where ADB resources are created
- `adb_password`: administrator password for the database
- `adb_database_db_name`: database name
- `adb_database_display_name`: display name
- `adb_database_db_workload`: workload type such as `OLTP` or `DW`
- `adb_compute_model`: `ECPU` or legacy `OCPU`
- `adb_compute_count`: compute amount for `ECPU`
- `adb_database_cpu_core_count`: CPU core count for non-`ECPU` mode
- `adb_database_data_storage_size_in_tbs`: allocated storage
- `adb_free_tier`: deploy Free Tier shape when supported
- `adb_private_endpoint`: enable private endpoint deployment
- `use_existing_vcn`: reuse existing subnet/NSG instead of creating network resources
- `vcn_id`: existing VCN OCID for private endpoint mode
- `adb_subnet_id`: existing subnet OCID for private endpoint mode
- `adb_nsg_id`: existing NSG OCID for private endpoint mode
- `whitelisted_ips`: public access allowlist when private endpoint is disabled
- `adb_backup_enabled`: create a manual backup after database provisioning
- `use_oci_vault`: enable customer-managed encryption key integration
- `source_type`: source mode for clone or disaster recovery scenarios

The full variable contract is defined in [variables.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/variables.tf).

---

## Outputs

The module exports:

- `adb_database`: database ID, connection URLs, wallet content, NSG ID, and private endpoint IP
- `adb_database_backup`: backup identifiers when manual backup creation is enabled
- `adb_database_network`: VCN, subnet, and NSG IDs when the module creates private endpoint networking

The exact output contract is defined in [outputs.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/outputs.tf).

---

## Design Principles

- The root module stays reusable instead of becoming a full database platform wrapper
- Network, encryption, and recovery concerns stay explicit
- Training lessons build on one another, but each lesson remains runnable on its own
- Outputs are treated as first-class values for downstream lessons and examples

---

## Notes

- Private endpoint networking is created only when `adb_private_endpoint = true` and `use_existing_vcn = false`.
- OCI Vault integration assumes the Vault and KMS key already exist.
- The current root module still manages private endpoint networking with raw OCI resources.
- The current repository owner and module source remain `mlinxfeld`; that can be aligned later if the repo is transferred.

---

## Related Resources

- [Training examples](training)
- [FoggyKitchen.com](https://foggykitchen.com/)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
