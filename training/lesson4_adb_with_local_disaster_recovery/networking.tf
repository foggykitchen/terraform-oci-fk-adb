module "fk_vcn" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git?ref=v0.1.0"

  compartment_ocid = var.compartment_ocid
  name             = "FoggyKitchenADBVCN"
  vcn_cidr_blocks  = ["10.0.0.0/16"]
  dns_label        = "fkadbvcn"

  create_nat_gateway     = true
  create_service_gateway = true

  route_tables = {
    private = {
      display_name = "FoggyKitchenADBPrivateRouteTable"
      route_rules = [
        {
          description        = "Traffic to the internet"
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "nat_gateway"
        },
        {
          description        = "Traffic to OCI services"
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
          network_entity_key = "service_gateway"
        }
      ]
    }
  }

  subnets = {
    adb_private = {
      cidr_block                    = "10.0.1.0/24"
      dns_label                     = "adbnet"
      route_table_key               = "private"
      prohibit_public_ip_on_vnic    = true
      include_default_security_list = false
    }
  }
}

module "fk_nsg" {
  source = "github.com/foggykitchen/terraform-oci-fk-nsg"

  name             = "FoggyKitchenADBNSG"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.fk_vcn.vcn_id

  security_rules = [
    {
      name        = "allow-adb-ingress-1522"
      direction   = "INGRESS"
      protocol    = "6"
      source      = "10.0.0.0/16"
      source_type = "CIDR_BLOCK"
      tcp_options = {
        destination_port_range = {
          min = 1522
          max = 1522
        }
      }
      description = "Allow ADB private endpoint access from within the VCN on port 1522."
    },
    {
      name             = "allow-vcn-egress"
      direction        = "EGRESS"
      protocol         = "6"
      destination      = "10.0.0.0/16"
      destination_type = "CIDR_BLOCK"
      description      = "Allow outbound traffic from the ADB NSG to the VCN CIDR."
    }
  ]
}
