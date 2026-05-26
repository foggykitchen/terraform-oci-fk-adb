module "vcn_primary" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git?ref=v0.1.0"

  providers = {
    oci = oci.primary
  }

  compartment_ocid = var.compartment_ocid
  name             = "FoggyKitchenADBPrimaryVCN"
  vcn_cidr_blocks  = ["10.30.0.0/16"]
  dns_label        = "fkadbpri"

  create_nat_gateway     = true
  create_service_gateway = true

  extra_network_entity_ids = {
    drg = module.drg_primary.drg_id
  }

  route_tables = {
    private = {
      display_name = "FoggyKitchenADBPrimaryPrivateRouteTable"
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
        },
        {
          description        = "Remote standby VCN through DRG"
          destination        = "10.40.0.0/16"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "drg"
        }
      ]
    }
  }

  subnets = {
    adb_private = {
      display_name                  = "FoggyKitchenADBPrimarySubnet"
      cidr_block                    = "10.30.1.0/24"
      dns_label                     = "adbpri"
      route_table_key               = "private"
      include_default_security_list = false
      prohibit_internet_ingress     = true
      prohibit_public_ip_on_vnic    = true
    }
  }
}

module "drg_primary" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-drg.git?ref=v0.4.0"

  providers = {
    oci = oci.primary
  }

  compartment_ocid = var.compartment_ocid
  name             = "FoggyKitchenADBPrimaryDRG"

  vcn_attachments = {
    adb = {
      vcn_id              = module.vcn_primary.vcn_id
      drg_route_table_key = "from-vcn"
    }
  }

  remote_peering_connections = {
    peer = {
      display_name = "FoggyKitchenADBPrimaryRPC"
    }
  }

  drg_route_tables = {
    from-vcn = {
      display_name = "FoggyKitchenADBPrimaryFromVCN"
      route_rules = [
        {
          destination                            = "10.40.0.0/16"
          destination_type                       = "CIDR_BLOCK"
          next_hop_rpc_attachment_management_key = "peer"
        }
      ]
    }
    from-rpc = {
      display_name = "FoggyKitchenADBPrimaryFromRPC"
      route_rules = [
        {
          destination             = "10.30.0.0/16"
          destination_type        = "CIDR_BLOCK"
          next_hop_attachment_key = "adb"
        }
      ]
    }
  }

  rpc_attachment_managements = {
    peer = {
      rpc_key             = "peer"
      drg_route_table_key = "from-rpc"
    }
  }
}

module "nsg_primary" {
  source = "github.com/foggykitchen/terraform-oci-fk-nsg"

  providers = {
    oci = oci.primary
  }

  name             = "FoggyKitchenADBPrimaryNSG"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.vcn_primary.vcn_id

  security_rules = [
    {
      name        = "allow-primary-vcn-ingress-1522"
      direction   = "INGRESS"
      protocol    = "6"
      source      = "10.30.0.0/16"
      source_type = "CIDR_BLOCK"
      tcp_options = {
        destination_port_range = {
          min = 1522
          max = 1522
        }
      }
      description = "Allow ADB private endpoint access from the primary VCN on port 1522."
    },
    {
      name        = "allow-standby-vcn-ingress-1522"
      direction   = "INGRESS"
      protocol    = "6"
      source      = "10.40.0.0/16"
      source_type = "CIDR_BLOCK"
      tcp_options = {
        destination_port_range = {
          min = 1522
          max = 1522
        }
      }
      description = "Allow ADB private endpoint access from the standby VCN on port 1522."
    },
    {
      name             = "allow-primary-standby-egress"
      direction        = "EGRESS"
      protocol         = "6"
      destination      = "10.40.0.0/16"
      destination_type = "CIDR_BLOCK"
      description      = "Allow outbound traffic from the primary ADB NSG to the standby VCN CIDR."
    },
    {
      name             = "allow-primary-local-egress"
      direction        = "EGRESS"
      protocol         = "6"
      destination      = "10.30.0.0/16"
      destination_type = "CIDR_BLOCK"
      description      = "Allow outbound traffic from the primary ADB NSG to the primary VCN CIDR."
    }
  ]
}

module "vcn_standby" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git?ref=v0.1.0"

  providers = {
    oci = oci.standby
  }

  compartment_ocid = var.compartment_ocid
  name             = "FoggyKitchenADBStandbyVCN"
  vcn_cidr_blocks  = ["10.40.0.0/16"]
  dns_label        = "fkadbstb"

  create_nat_gateway     = true
  create_service_gateway = true

  extra_network_entity_ids = {
    drg = module.drg_standby.drg_id
  }

  route_tables = {
    private = {
      display_name = "FoggyKitchenADBStandbyPrivateRouteTable"
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
        },
        {
          description        = "Remote primary VCN through DRG"
          destination        = "10.30.0.0/16"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "drg"
        }
      ]
    }
  }

  subnets = {
    adb_private = {
      display_name                  = "FoggyKitchenADBStandbySubnet"
      cidr_block                    = "10.40.1.0/24"
      dns_label                     = "adbstb"
      route_table_key               = "private"
      include_default_security_list = false
      prohibit_internet_ingress     = true
      prohibit_public_ip_on_vnic    = true
    }
  }
}

module "drg_standby" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-drg.git?ref=v0.4.0"

  providers = {
    oci = oci.standby
  }

  compartment_ocid = var.compartment_ocid
  name             = "FoggyKitchenADBStandbyDRG"

  vcn_attachments = {
    adb = {
      vcn_id              = module.vcn_standby.vcn_id
      drg_route_table_key = "from-vcn"
    }
  }

  remote_peering_connections = {
    peer = {
      display_name     = "FoggyKitchenADBStandbyRPC"
      peer_id          = module.drg_primary.remote_peering_connection_ids["peer"]
      peer_region_name = var.primary_region
    }
  }

  drg_route_tables = {
    from-vcn = {
      display_name = "FoggyKitchenADBStandbyFromVCN"
      route_rules = [
        {
          destination                            = "10.30.0.0/16"
          destination_type                       = "CIDR_BLOCK"
          next_hop_rpc_attachment_management_key = "peer"
        }
      ]
    }
    from-rpc = {
      display_name = "FoggyKitchenADBStandbyFromRPC"
      route_rules = [
        {
          destination             = "10.40.0.0/16"
          destination_type        = "CIDR_BLOCK"
          next_hop_attachment_key = "adb"
        }
      ]
    }
  }

  rpc_attachment_managements = {
    peer = {
      rpc_key             = "peer"
      drg_route_table_key = "from-rpc"
    }
  }
}

module "nsg_standby" {
  source = "github.com/foggykitchen/terraform-oci-fk-nsg"

  providers = {
    oci = oci.standby
  }

  name             = "FoggyKitchenADBStandbyNSG"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.vcn_standby.vcn_id

  security_rules = [
    {
      name        = "allow-standby-vcn-ingress-1522"
      direction   = "INGRESS"
      protocol    = "6"
      source      = "10.40.0.0/16"
      source_type = "CIDR_BLOCK"
      tcp_options = {
        destination_port_range = {
          min = 1522
          max = 1522
        }
      }
      description = "Allow ADB private endpoint access from the standby VCN on port 1522."
    },
    {
      name        = "allow-primary-vcn-ingress-1522"
      direction   = "INGRESS"
      protocol    = "6"
      source      = "10.30.0.0/16"
      source_type = "CIDR_BLOCK"
      tcp_options = {
        destination_port_range = {
          min = 1522
          max = 1522
        }
      }
      description = "Allow ADB private endpoint access from the primary VCN on port 1522."
    },
    {
      name             = "allow-standby-primary-egress"
      direction        = "EGRESS"
      protocol         = "6"
      destination      = "10.30.0.0/16"
      destination_type = "CIDR_BLOCK"
      description      = "Allow outbound traffic from the standby ADB NSG to the primary VCN CIDR."
    },
    {
      name             = "allow-standby-local-egress"
      direction        = "EGRESS"
      protocol         = "6"
      destination      = "10.40.0.0/16"
      destination_type = "CIDR_BLOCK"
      description      = "Allow outbound traffic from the standby ADB NSG to the standby VCN CIDR."
    }
  ]
}
