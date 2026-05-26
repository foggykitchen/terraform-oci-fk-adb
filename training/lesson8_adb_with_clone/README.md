# Lesson 8: Autonomous Database with Full Clone

This lesson extends the private endpoint deployment path by introducing full database cloning for Autonomous Database Serverless. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking modules and optionally creates a full clone from the source database.

![](lesson8_adb_with_clone.png)

## What This Lesson Shows

- An Autonomous Database Serverless source deployment with a private endpoint
- Reusable `terraform-oci-fk-vcn` and `terraform-oci-fk-nsg` modules composed with `terraform-oci-fk-adb`
- Optional full clone creation from the source database
- The progression from [lesson7](../lesson7_adb_with_oci_vault/) toward clone-driven workflows

This lesson keeps the explicit networking composition introduced in [lesson3](../lesson3_adb_with_private_endpoint/) and reused in [lesson4](../lesson4_adb_with_local_disaster_recovery/), [lesson5](../lesson5_adb_with_local_data_guard/), [lesson6](../lesson6_adb_with_manual_backup/), and [lesson7](../lesson7_adb_with_oci_vault/).

## Architecture Notes

This lesson uses:

- the local ADB module via `../..` for the source database
- the local ADB module via `../..` for the optional full clone
- `terraform-oci-fk-vcn` for the VCN, subnet, route table, NAT gateway, and service gateway
- `terraform-oci-fk-nsg` for the ADB NSG and rules
- a shared private ADB endpoint subnet and NSG for both databases
- `adb_full_clone_enabled` to control whether the clone is created

The networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson8_adb_with_clone/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson8_adb_with_clone/adb_UPDATED.tf), and OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson8_adb_with_clone/provider.tf).

The key difference from earlier lessons is that this scenario uses an existing source database ID as the clone source. The networking pattern stays explicit and shared, but the data plane expands from a single database to an optional second database created as a full clone.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/mlinxfeld/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson8_adb_with_clone
```

### Create `terraform.tfvars`

Start from the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Minimum required values:

```hcl
tenancy_ocid           = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
user_ocid              = "ocid1.user.oc1..<your_user_ocid>"
compartment_ocid       = "ocid1.compartment.oc1..<your_compartment_ocid>"
region                 = "<oci_region>"
fingerprint            = "<fingerprint>"
private_key_path       = "<private_key_path>"
adb_password           = "<adb_password>"
adb_full_clone_enabled = false
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the ADB modules
- `terraform-oci-fk-vcn` for networking
- `terraform-oci-fk-nsg` for NSG resources

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- one source Autonomous Database Serverless instance
- one generated wallet password for the source database
- one source database wallet download resource
- one VCN
- one subnet
- one route table
- one NAT gateway
- one service gateway
- one NSG with ingress and egress rules

If you enable `adb_full_clone_enabled = true`, the lesson also creates:

- one full clone Autonomous Database Serverless instance
- one generated wallet password for the clone
- one clone database wallet download resource

## Key Configuration

Current lesson settings:

- `adb_database_db_name = "FoggyKitchenADBSource"` for the source
- `adb_database_display_name = "FoggyKitchenADB_Source"` for the source
- `adb_database_db_name = "FoggyKitchenADBFullClone"` for the clone
- `adb_database_display_name = "FoggyKitchenADB_FullClone"` for the clone
- `adb_database_db_workload = "OLTP"`
- `adb_free_tier = false`
- `adb_database_cpu_core_count = 1`
- `adb_database_data_storage_size_in_tbs = 1`
- `use_existing_vcn = true`
- `adb_private_endpoint = true`
- `adb_subnet_id = module.fk_vcn.subnet_ids["adb_private"]`
- `adb_nsg_id = module.fk_nsg.nsg_id`
- `source_type = "DATABASE"` for the clone
- `clone_type = "FULL"` for the clone
- `adb_full_clone_enabled = false`

The important behavioral point is that this lesson keeps the explicit networking composition from [lesson3](../lesson3_adb_with_private_endpoint/) through [lesson7](../lesson7_adb_with_oci_vault/), but introduces source-based cloning as the next layer of lifecycle management.

## Outputs

This lesson exposes the outputs from the root module, including:

- database identifiers and connection URLs for the source database
- wallet content for the source database
- network details for the private endpoint path

When the clone is enabled, the lesson also creates a second set of database and wallet resources for the clone.

## Destroy

To remove all resources created by this lesson:

```bash
terraform destroy
```

## Contributing

This project is open source. Contributions are welcome through pull requests.

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
