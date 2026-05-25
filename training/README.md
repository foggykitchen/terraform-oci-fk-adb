# FoggyKitchen OCI Autonomous Database Serverless with Terraform

This directory contains the progressive examples used in the FoggyKitchen Autonomous Database Serverless training track.

Each lesson builds on the previous one, moving from a minimal Free Tier deployment through public endpoint controls, private endpoints, disaster recovery, backup, Vault integration, cloning, and compute model changes.

The 2026 codebase prefers reusable module composition over large one-off examples wherever that makes the architecture clearer and more maintainable.

![](terraform-oci-fk-atp-lessons.png)

---

## Example Overview

| Lesson | Title | Key Topics |
|---:|---|---|
| 01 | [**Free Tier ADB**](lesson1_free_tier_adb/) | Minimal Autonomous Database Serverless deployment |
| 02 | [**Free Tier ADB with IP Whitelisting**](lesson2_free_tier_adb_with_ip_whitelisting/) | Public endpoint allowlisting |
| 03 | [**ADB with Private Endpoint**](lesson3_adb_with_private_endpoint/) | Private endpoint networking and NSG composition |
| 04 | [**ADB with Local Disaster Recovery**](lesson4_adb_with_local_disaster_recovery/) | In-region disaster recovery path |
| 05 | [**ADB with Local Data Guard**](lesson5_adb_with_local_data_guard/) | Local Data Guard |
| 06 | [**ADB with Manual Backup**](lesson6_adb_with_manual_backup/) | Manual backup creation |
| 07 | [**ADB with OCI Vault**](lesson7_adb_with_oci_vault/) | Customer-managed encryption keys |
| 08 | [**ADB with Full Clone**](lesson8_adb_with_clone/) | Clone-based database creation |
| 09 | [**ADB with Refreshable Clone**](lesson9_adb_with_refreshable_clone/) | Refreshable clone workflow |
| 10 | [**ADB with Remote Disaster Recovery**](lesson10_adb_with_remote_disaster_recovery/) | Cross-region standby without Data Guard |
| 11 | [**ADB with Remote Data Guard**](lesson11_adb_with_remote_data_guard/) | Cross-region Data Guard |
| 12 | [**ADB with ECPU Compute Model**](lesson12_adb_with_ecpu_compute_model/) | ECPU-based sizing model |

---

## How To Use

Each lesson directory includes:

- Terraform configuration files
- Architecture or deployment screenshots
- A step-by-step `README.md`
- A `terraform.tfvars.example` starter file

To run a lesson:

```bash
cd training/lesson1_free_tier_adb
terraform init
terraform apply
```

The lessons can be applied independently, but the recommended learning path is sequential:

01 -> 02 -> 03 -> 04 -> 05 -> 06 -> 07 -> 08 -> 09 -> 10 -> 11 -> 12

---

## Design Principles

- One lesson equals one architectural goal
- Dependencies stay explicit
- The module under test is always the local OCI ADB module
- Training examples should be runnable on their own
- Documentation should mirror the actual module contract

The training examples intentionally avoid:

- Full landing zones
- Hidden dependencies between lessons
- Opinionated enterprise wrappers

---

## Related Resources

- [FoggyKitchen ADB Module](../README.md)
- [FoggyKitchen.com](https://foggykitchen.com/)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
