# Lesson 7: Autonomous Database with OCI Vault

This lesson extends the private endpoint deployment path by integrating Autonomous Database Serverless with OCI Vault. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking and IAM modules, allowing the database to use a customer-managed master encryption key stored in OCI Vault.

![](lesson7_adb_with_oci_vault.png)

## What This Lesson Shows

- An Autonomous Database Serverless deployment with a private endpoint
- Reusable `terraform-oci-fk-vcn` and `terraform-oci-fk-nsg` modules composed with `terraform-oci-fk-adb`
- Reusable `terraform-oci-fk-policy` for the dynamic group and tenancy policy required by OCI Vault integration
- OCI Vault integration through `vault_id` and `kms_key_id`
- The progression from [lesson6](../lesson6_adb_with_manual_backup/) toward customer-managed encryption

This lesson keeps the explicit networking composition introduced in [lesson3](../lesson3_adb_with_private_endpoint/) and reused in [lesson4](../lesson4_adb_with_local_disaster_recovery/), [lesson5](../lesson5_adb_with_local_data_guard/), and [lesson6](../lesson6_adb_with_manual_backup/).

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnet, route table, NAT gateway, and service gateway
- `terraform-oci-fk-nsg` for the ADB NSG and rules
- `terraform-oci-fk-policy` for the required dynamic group and tenancy-level policy
- a private ADB endpoint
- an existing OCI Vault and KMS key passed as inputs

The networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson7_adb_with_oci_vault/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson7_adb_with_oci_vault/adb_UPDATED.tf), IAM policy composition is in [iam_NEW.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson7_adb_with_oci_vault/iam_NEW.tf), and OCI provider authentication is configured in [provider_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson7_adb_with_oci_vault/provider_UPDATED.tf).

The key difference from earlier lessons is that this scenario introduces customer-managed encryption. The database still follows the same private networking pattern, but now depends on OCI Vault access being granted through a dynamic group and tenancy-level policy.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson7_adb_with_oci_vault
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
vault_id         = "<vault_ocid>"
kms_key_id       = "<kms_key_id>"
```

### Initialize Terraform

```bash
terraform init
```

Expected module sources:

- local `../..` for the ADB module
- `terraform-oci-fk-vcn` for networking
- `terraform-oci-fk-nsg` for NSG resources
- `terraform-oci-fk-policy` for IAM resources

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
- one dynamic group
- one tenancy-level IAM policy

The lesson expects that the OCI Vault and KMS key already exist. It does not create Vault resources itself.

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
- `use_oci_vault = true`
- `vault_id = var.vault_id`
- `kms_key_id = var.kms_key_id`

The important behavioral point is that this lesson keeps the explicit networking composition from [lesson3](../lesson3_adb_with_private_endpoint/) through [lesson6](../lesson6_adb_with_manual_backup/), but adds explicit OCI IAM composition and customer-managed encryption through OCI Vault.

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
