# Lesson 11: Autonomous Database with Remote Autonomous Data Guard

This lesson extends the cross-region private endpoint pattern from [lesson10](../lesson10_adb_with_remote_disaster_recovery/) by switching the standby database from backup-based remote disaster recovery to remote Autonomous Data Guard. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking modules and a cross-region DRG remote peering pattern based on the `terraform-oci-fk-drg` remote peering example.

![](lesson11_adb_with_remote_data_guard.png)

## What This Lesson Shows

- A primary Autonomous Database Serverless deployment with a private endpoint
- A standby Autonomous Database Serverless deployment in another OCI region
- Reusable `terraform-oci-fk-vcn`, `terraform-oci-fk-nsg`, and `terraform-oci-fk-drg` modules composed across two regions
- Remote Autonomous Data Guard through `source_type = "CROSS_REGION_DISASTER_RECOVERY"` and `remote_disaster_recovery_type = "ADG"`
- The progression from [lesson10](../lesson10_adb_with_remote_disaster_recovery/) toward a higher protection premium DR option

This lesson keeps the explicit networking composition introduced in [lesson3](../lesson3_adb_with_private_endpoint/) and the cross-region DRG topology introduced in [lesson10](../lesson10_adb_with_remote_disaster_recovery/), but changes the standby protection model to Autonomous Data Guard.

## Architecture Notes

This lesson uses:

- the local ADB module via `../..` for the primary database
- the local ADB module via `../..` for the standby database
- `terraform-oci-fk-vcn` for one VCN in the primary region and one VCN in the standby region
- `terraform-oci-fk-nsg` for one ADB NSG per region
- `terraform-oci-fk-drg` for one DRG per region and remote peering connections between them
- private ADB endpoints in both regions
- remote Autonomous Data Guard with `remote_disaster_recovery_type = "ADG"`

The cross-region networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson11_adb_with_remote_data_guard/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson11_adb_with_remote_data_guard/adb_UPDATED.tf), and OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson11_adb_with_remote_data_guard/provider.tf).

The key difference from [lesson10](../lesson10_adb_with_remote_disaster_recovery/) is the disaster recovery tier. Lesson10 keeps the lower-cost backup-based standby path, while this lesson uses the premium Autonomous Data Guard standby model with lower recovery targets and a stronger protection posture.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/mlinxfeld/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson11_adb_with_remote_data_guard
```

### Create `terraform.tfvars`

Start from the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Minimum required values:

```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
user_ocid        = "ocid1.user.oc1..<your_user_ocid>"
compartment_ocid = "ocid1.compartment.oc1..<your_compartment_ocid>"
primary_region   = "<primary_region>"
standby_region   = "<standby_region>"
fingerprint      = "<fingerprint>"
private_key_path = "<private_key_path>"
adb_password     = "<adb_password>"
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the ADB modules
- `terraform-oci-fk-vcn` for networking
- `terraform-oci-fk-nsg` for NSG resources
- `terraform-oci-fk-drg` for cross-region DRG and remote peering

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- one primary Autonomous Database Serverless instance
- one standby Autonomous Database Serverless instance
- one generated wallet password and wallet download for the primary database
- one generated wallet password and wallet download for the standby database
- one primary VCN and one standby VCN
- one primary subnet and one standby subnet
- one primary DRG and one standby DRG
- one remote peering connection on each side
- one primary NSG and one standby NSG
- route tables, NAT gateways, and service gateways in both regions

## Key Configuration

Current lesson settings:

- `adb_database_display_name = "FoggyKitchenADB_Source"` for the primary database
- `adb_database_display_name = "FoggyKitchenADB_Standby"` for the standby database
- `use_existing_vcn = true` in both regions
- `adb_private_endpoint = true` in both regions
- `source_type = "CROSS_REGION_DISASTER_RECOVERY"` for the standby database
- `remote_disaster_recovery_type = "ADG"` for the standby database
- primary VCN CIDR: `10.30.0.0/16`
- standby VCN CIDR: `10.40.0.0/16`

The important behavioral point is that this lesson uses the same explicit module composition style as [lesson10](../lesson10_adb_with_remote_disaster_recovery/), but upgrades the standby model from backup-based DR to Remote Autonomous Data Guard.

## Outputs

This lesson exposes the outputs from both ADB module instances, including:

- primary and standby database identifiers and connection URLs
- wallet content for both databases
- network details for the primary and standby private endpoint paths

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
