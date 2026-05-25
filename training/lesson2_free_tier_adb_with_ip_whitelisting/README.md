# Lesson 2: Free Tier Autonomous Database with IP Whitelisting

This lesson extends the basic Free Tier ADB scenario by adding explicit IP whitelisting for the public endpoint. It uses the local `terraform-oci-fk-adb` module and restricts access to the database to a single public IP address.

![](lesson2_free_tier_adb_with_ip_whitelisting.png)

## What This Lesson Shows

- A Free Tier Autonomous Database Serverless deployment on OCI
- Public endpoint access with explicit IP allowlisting
- Module usage through the local `terraform-oci-fk-adb` root module
- The progression from lesson1 public access to a more controlled public endpoint model

This lesson is the first place in the training track where `whitelisted_ips` are used intentionally. Unlike lesson1, the allowlist is part of the scenario itself.

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- a public ADB endpoint
- Free Tier sizing with a small storage allocation
- one explicit public IP address in `whitelisted_ips`
- no module-created private endpoint networking

The lesson configuration lives in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson2_free_tier_adb_with_ip_whitelisting/adb_UPDATED.tf), while OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson2_free_tier_adb_with_ip_whitelisting/provider.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/mlinxfeld/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson2_free_tier_adb_with_ip_whitelisting
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
my_public_ip     = "<your_public_ip>"
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

The database is created with:

- `whitelisted_ips = [var.my_public_ip]`

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
- `whitelisted_ips = [var.my_public_ip]`

The important behavioral point is that this lesson keeps the public endpoint model from lesson1, but now constrains connectivity to a single public IP address.

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
