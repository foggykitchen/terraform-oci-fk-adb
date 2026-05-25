# Lesson 1: Free Tier Autonomous Database Serverless

This lesson introduces the smallest ADB scenario in the repository: a Free Tier Autonomous Database Serverless deployment with a public endpoint. It uses the local `terraform-oci-fk-adb` module and keeps the architecture intentionally simple.

![](lesson1_free_tier_adb.png)

## What This Lesson Shows

- A minimal Autonomous Database Serverless deployment on OCI Free Tier
- Public endpoint access without private endpoint networking
- Module usage through the local `terraform-oci-fk-adb` root module
- A simple baseline for later ADB lessons

This lesson is the starting point for the rest of the training track. It focuses on the smallest possible ADB path before introducing IP allowlists, private endpoints, backup, Vault, cloning, and disaster recovery.

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- a public ADB endpoint
- Free Tier sizing with a small storage allocation
- no module-created VCN, subnet, or NSG resources

The lesson configuration lives in [adb.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson1_free_tier_adb/adb.tf), while OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson1_free_tier_adb/provider.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/mlinxfeld/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson1_free_tier_adb
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
region           = "<oci_region>"
fingerprint      = "<fingerprint>"
private_key_path = "<private_key_path>"
adb_password     = "<adb_password>"
```

### Initialize Terraform

```bash
terraform init
```

Expected module source:

- local `../..` for the ADB module

### Apply

```bash
terraform apply
```

With the current defaults, this lesson creates:

- one Free Tier Autonomous Database Serverless instance
- one generated wallet password
- one database wallet download resource

## Key Configuration

Current lesson settings:

- `adb_database_db_name = "FoggyKitchenFreeTierADB"`
- `adb_database_display_name = "FoggyKitchenFreeTierADB"`
- `adb_database_db_workload = "OLTP"`
- `adb_free_tier = true`
- `adb_database_cpu_core_count = 1`
- `adb_database_data_storage_size_in_tbs = 1`
- `use_existing_vcn = false`
- `adb_private_endpoint = false`

The important behavioral point is that this lesson does not use private endpoint networking, so the root module only provisions the database and wallet resources.

## Outputs

This lesson exposes the outputs from the root module, including:

- database identifiers and connection URLs
- wallet content
- backup information when enabled
- network information when private endpoint networking is created

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
