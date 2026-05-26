# Lesson 3: Autonomous Database with Private Endpoint

This lesson introduces private endpoint deployment for Autonomous Database Serverless. It uses the local `terraform-oci-fk-adb` module together with reusable FoggyKitchen networking modules to create the private networking path needed by the database.

![](lesson3_adb_with_private_endpoint.png)

## What This Lesson Shows

- An Autonomous Database Serverless deployment with a private endpoint
- Reusable `terraform-oci-fk-vcn` and `terraform-oci-fk-nsg` modules composed with `terraform-oci-fk-adb`
- Module usage through the local `terraform-oci-fk-adb` root module
- The shift from public endpoint lessons to a network-isolated ADB path

This lesson is the first point in the training track where the database is composed with separate OCI networking modules instead of relying on hidden networking inside the ADB module.

## Architecture Notes

This lesson uses:

- the local ADB module via `../..`
- `terraform-oci-fk-vcn` for the VCN, subnet, route table, NAT gateway, and service gateway
- `terraform-oci-fk-nsg` for the ADB NSG and rules
- a private ADB endpoint
- no public IP allowlist, because the database is not exposed through a public endpoint

The networking composition lives in [networking.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson3_adb_with_private_endpoint/networking.tf), the database configuration is in [adb_UPDATED.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson3_adb_with_private_endpoint/adb_UPDATED.tf), and OCI provider authentication is configured in [provider.tf](/Users/mlinxfeld/codes/github/terraform-oci-fk-adb/training/lesson3_adb_with_private_endpoint/provider.tf).

## Deploy Using Terraform CLI

### Clone The Repository

```bash
git clone https://github.com/foggykitchen/terraform-oci-fk-adb.git
cd terraform-oci-fk-adb/training/lesson3_adb_with_private_endpoint
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

The important behavioral point is that this lesson intentionally composes the database with dedicated networking modules and then feeds the resulting subnet and NSG IDs into the ADB module.

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
