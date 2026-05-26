module "fk_policy_vault" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-policy.git?ref=v0.1.0"

  providers = {
    oci = oci.homeregion
  }

  tenancy_ocid = var.tenancy_ocid

  dynamic_group = {
    name          = "FoggyKitchenDynamicGroup"
    description   = "FoggyKitchen Dynamic Group"
    matching_rule = "All {resource.compartment.id = '${var.compartment_ocid}'}"
  }

  policies = [
    {
      name        = "FoggyKitchenPolicy"
      description = "FoggyKitchen Policy (use of OCI Vault in tenancy)"
      statements = [
        "Allow dynamic-group FoggyKitchenDynamicGroup to use vaults in tenancy",
        "Allow dynamic-group FoggyKitchenDynamicGroup to use keys in tenancy",
      ]
    }
  ]
}
