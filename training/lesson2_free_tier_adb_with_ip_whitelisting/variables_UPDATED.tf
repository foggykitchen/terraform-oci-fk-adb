variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "adb_password" {}
variable "my_public_ip" {}
variable "mobile_public_ip" {
  default = ""
}

variable "fn_vcn_ocid" {
  default = ""
}

variable "fn_public_egress_ip" {
  default = ""
}
