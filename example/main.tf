module "gcp-aws-ha-vpn" {
  source = "../"

  prefix                = "gcp-to-aws"
  num_tunnels           = 4
  gcp_router_asn        = 65001
  project_id            = "ylebi-rnd"
  vpn_gwy_region        = "us-west1"
  shared_secret         = "EAyPyVfEZ7eDaetfSCOLu1r03Cb61XQ" # can only contain alphanumeric, period and underscore characters
  aws_router_asn        = 65002
  aws_vpc_cidr          = "11.1.0.0/16"
  aws_private_subnets   = ["subnet-15b6a13a", "subnet-577f9430"]
  aws_vpc_id            = "vpc-c52256be"
  aws_security_group_id = "sg-17c6175e"
  sg_ingress_port       = [3306, 443]
  aws_route_table_ids   = ["rtb-4a412f36", "rtb-0e492772"]
  gcp_network           = "test-usw1-vpc"
  gcp_subnet_cidrs      = ["10.100.0.0/20", "10.100.16.0/20", "10.100.35.0/25"]
}
