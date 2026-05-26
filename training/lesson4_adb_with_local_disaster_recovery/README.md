# Lesson 4: Autonomous Database with Local Disaster Recovery

This lesson extends the private endpoint deployment path by introducing the local backup-based disaster recovery baseline for Autonomous Database Serverless. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking modules.

![](lesson4_adb_with_local_disaster_recovery.png)

## What This Lesson Shows

- An Autonomous Database Serverless deployment with a private endpoint
- Reusable `terraform-oci-fk-vcn` and `terraform-oci-fk-nsg` modules composed with `terraform-oci-fk-adb`
- The default local backup-based disaster recovery behavior
- The progression from private endpoint connectivity toward higher availability scenarios before introducing premium Local Autonomous Data Guard in [lesson5](../lesson5_adb_with_local_data_guard/)

This lesson builds directly on the private endpoint pattern from [lesson3](../lesson3_adb_with_private_endpoint/) and keeps the same explicit networking composition model.

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnet, route table, NAT gateway, and service gateway
- `terraform-oci-fk-nsg` for the ADB NSG and rules
- a private ADB endpoint
- backup-based local disaster recovery with `is_local_data_guard_enabled = false`

The networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson4_adb_with_local_disaster_recovery/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson4_adb_with_local_disaster_recovery/adb_UPDATED.tf), and OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson4_adb_with_local_disaster_recovery/provider.tf).

Oracle positions this as the lower-cost local resilience path. Local Autonomous Data Guard, covered separately in [lesson5](../lesson5_adb_with_local_data_guard/), is the premium option with a lower RTO.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/mlinxfeld/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson4_adb_with_local_disaster_recovery
```

### Create `terraform.tfvars`

Start from the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Minimum required values:

```hcl
tenancy_ocid                = "ocid1.tenancy.oc1..<your_tenancy_ocid>"
user_ocid                   = "ocid1.user.oc1..<your_user_ocid>"
compartment_ocid            = "ocid1.compartment.oc1..<your_compartment_ocid>"
region                      = "<oci_region>"
fingerprint                 = "<fingerprint>"
private_key_path            = "<private_key_path>"
adb_password                = "<adb_password>"
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
- one VCN
- one subnet
- one route table
- one NAT gateway
- one service gateway
- one NSG with ingress and egress rules

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
- `is_local_data_guard_enabled = false`

The important behavioral point is that this lesson keeps the explicit networking composition from [lesson3](../lesson3_adb_with_private_endpoint/) and leaves Local Autonomous Data Guard disabled on purpose. That makes [lesson4](./) the baseline backup-based disaster recovery path, while [lesson5](../lesson5_adb_with_local_data_guard/) remains the premium Local Autonomous Data Guard option.

## Outputs

This lesson exposes the outputs from the root module, including:

- database identifiers and connection URLs
- wallet content
- backup information when enabled
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
