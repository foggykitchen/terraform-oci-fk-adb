# Lesson 6: Autonomous Database with Manual Backup

This lesson extends the private endpoint deployment path by enabling manual long-term backup creation for Autonomous Database Serverless. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking modules and optionally creates a second database cloned from the manual backup.

![](lesson6_adb_with_manual_backup.png)

## What This Lesson Shows

- An Autonomous Database Serverless deployment with a private endpoint
- Reusable `terraform-oci-fk-vcn` and `terraform-oci-fk-nsg` modules composed with `terraform-oci-fk-adb`
- Manual long-term backup creation through the root module
- Optional full clone creation from the generated backup
- The progression from [lesson5](../lesson5_adb_with_local_data_guard/) toward backup and clone workflows

This lesson keeps the explicit networking composition introduced in [lesson3](../lesson3_adb_with_private_endpoint/) and reused in [lesson4](../lesson4_adb_with_local_disaster_recovery/) and [lesson5](../lesson5_adb_with_local_data_guard/).

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnet, route table, NAT gateway, and service gateway
- `terraform-oci-fk-nsg` for the ADB NSG and rules
- a private ADB endpoint for the primary database
- an optional private clone created from a manual backup
- `adb_backup_enabled = true` by default

The networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson6_adb_with_manual_backup/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson6_adb_with_manual_backup/adb_UPDATED.tf), and OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson6_adb_with_manual_backup/provider.tf).

The key difference from earlier lessons is that this scenario keeps the same networking model but adds backup lifecycle behavior and an optional clone path based on the resulting backup ID.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson6_adb_with_manual_backup
```

### Create `terraform.tfvars`

Start from the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Minimum required values:

```hcl
tenancy_ocid          = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
user_ocid             = "ocid1.user.oc1..<your_user_ocid>"
compartment_ocid      = "ocid1.compartment.oc1..<your_compartment_ocid>"
region                = "<oci_region>"
fingerprint           = "<fingerprint>"
private_key_path      = "<private_key_path>"
adb_password          = "<adb_password>"
adb_backup_enabled    = true
adb_clone_from_backup = false
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the ADB module
- `terraform-oci-fk-vcn` for networking
- `terraform-oci-fk-nsg` for NSG resources

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- one Autonomous Database Serverless instance
- one generated wallet password
- one database wallet download resource
- one manual long-term backup
- one VCN
- one subnet
- one route table
- one NAT gateway
- one service gateway
- one NSG with ingress and egress rules

If you enable `adb_clone_from_backup = true`, the lesson also creates:

- one additional Autonomous Database Serverless clone
- one additional wallet download resource for the clone

## Key Configuration

Current lesson settings:

- `adb_database_db_name = "FoggyKitchenADB"`
- `adb_database_display_name = "FoggyKitchenADB"`
- `adb_database_db_workload = "OLTP"`
- `adb_free_tier = false`
- `adb_database_cpu_core_count = 1`
- `adb_database_data_storage_size_in_tbs = 1`
- `use_existing_vcn = true`
- `adb_private_endpoint = true`
- `adb_subnet_id = module.fk_vcn.subnet_ids["adb_private"]`
- `adb_nsg_id = module.fk_nsg.nsg_id`
- `adb_backup_enabled = true`
- `adb_clone_from_backup = false`

The important behavioral point is that this lesson keeps the explicit networking composition from [lesson3](../lesson3_adb_with_private_endpoint/), [lesson4](../lesson4_adb_with_local_disaster_recovery/), and [lesson5](../lesson5_adb_with_local_data_guard/), but shifts the scenario toward manual backup management and optional backup-based cloning.

## Outputs

This lesson exposes the outputs from the root module, including:

- database identifiers and connection URLs
- wallet content
- backup identifiers for the generated manual backup
- VCN, subnet, and NSG details for the private endpoint path

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
