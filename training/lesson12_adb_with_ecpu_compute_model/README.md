# Lesson 12: Autonomous Database with the ECPU Compute Model

This lesson introduces Autonomous Database Serverless using the ECPU compute model instead of the older OCPU sizing approach. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking modules to create a private endpoint deployment with autoscaling enabled for both compute and storage.

![](lesson12_adb_with_ecpu_compute_model.png)

## What This Lesson Shows

- An Autonomous Database Serverless deployment with a private endpoint
- The ECPU compute model through `adb_compute_model = "ECPU"`
- Reusable `terraform-oci-fk-vcn` and `terraform-oci-fk-nsg` modules composed with `terraform-oci-fk-adb`
- Autoscaling enabled for compute and storage
- The progression from [lesson3](../lesson3_adb_with_private_endpoint/) toward a newer compute sizing model

This lesson keeps the explicit networking composition introduced in [lesson3](../lesson3_adb_with_private_endpoint/), but changes the database sizing model to ECPU.

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnet, route table, NAT gateway, and service gateway
- `terraform-oci-fk-nsg` for the ADB NSG and rules
- a private ADB endpoint
- the ECPU compute model with autoscaling enabled

The networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson12_adb_with_ecpu_compute_model/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson12_adb_with_ecpu_compute_model/adb_UPDATED.tf), and OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson12_adb_with_ecpu_compute_model/provider.tf).

The key difference from earlier private endpoint lessons is that this example highlights the newer ECPU model and autoscaling behavior rather than the older CPU-core-count based sizing.

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson12_adb_with_ecpu_compute_model
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
- `adb_compute_model = "ECPU"`
- `adb_compute_count = 2`
- `adb_database_data_storage_size_in_tbs = 1`
- `is_auto_scaling_enabled = true`
- `is_auto_scaling_for_storage_enabled = true`
- `use_existing_vcn = true`
- `adb_private_endpoint = true`
- `adb_subnet_id = module.fk_vcn.subnet_ids["adb_private"]`
- `adb_nsg_id = module.fk_nsg.nsg_id`

The important behavioral point is that this lesson keeps the explicit module composition used in the modernized private endpoint lessons, while showing the newer ECPU-based sizing path for Autonomous Database Serverless.

## Outputs

This lesson exposes the outputs from the root module, including:

- database identifiers and connection URLs
- wallet content
- autoscaling-related database settings
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
