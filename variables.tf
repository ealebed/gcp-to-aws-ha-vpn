variable "project_id" {
  type        = string
  description = "The GCP project ID where resources will be deployed."
}

variable "vpn_gwy_region" {
  type        = string
  description = "The GCP region where the VPN gateway will be created."
}

variable "gcp_router_asn" {
  type        = string
  description = "The ASN (Autonomous System Number) for the GCP router."
}

variable "aws_router_asn" {
  type        = string
  description = "The ASN for the AWS router, used for BGP peering."
}

variable "aws_vpc_id" {
  type        = string
  description = "The VPC ID of the AWS environment where the resources will be created."
}

variable "gcp_network" {
  type        = string
  description = "Name of the GCP network."
}

variable "aws_vpc_cidr" {
  type        = string
  description = "The CIDR block of the AWS VPC."
}

variable "gcp_subnet_cidrs" {
  type        = list(string)
  description = "The CIDR block of the GCP subnets."
}

variable "aws_private_subnets" {
  type        = list(string)
  description = "A list of private subnets within the AWS VPC."
}

variable "aws_route_table_ids" {
  type        = list(string)
  description = "The ID of the AWS route tables to associate with the VPN connection."
}

variable "aws_security_group_id" {
  type        = string
  description = "The security group ID in AWS to allow traffic through the VPN."
}

variable "shared_secret" {
  type        = string
  description = "The shared secret for establishing the VPN tunnels."
}

variable "prefix" {
  type        = string
  description = "Prefix used for naming all the resources in GCP and AWS."
}

variable "sg_ingress_port" {
  type        = list(number)
  description = "Security group igress rule ports"
  default     = [3306]
}

variable "num_tunnels" {
  type        = number
  description = <<EOF
    Total number of VPN tunnels. This must be in multiples of 2 for redundancy, 
    with a minimum of 4 tunnels required for high availability.
  EOF
  validation {
    condition     = var.num_tunnels % 2 == 0
    error_message = "The number of tunnels must be a multiple of 2."
  }
  validation {
    condition     = var.num_tunnels >= 4
    error_message = "A minimum of 4 tunnels is required for high availability."
  }
}
