locals {
  default_num_ha_vpn_interfaces = 2
}

resource "aws_customer_gateway" "gwy" {
  count = local.default_num_ha_vpn_interfaces

  device_name = "${var.prefix}-gwy-${count.index}"
  bgp_asn     = var.gcp_router_asn
  type        = "ipsec.1"
  ip_address  = google_compute_ha_vpn_gateway.gwy.vpn_interfaces[count.index]["ip_address"]
}

resource "aws_ec2_transit_gateway" "tgw" {
  amazon_side_asn                 = var.aws_router_asn
  description                     = "EC2 transit gateway"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  vpn_ecmp_support                = "enable"
  dns_support                     = "enable"

  tags = {
    Name = "${var.prefix}-tgw"
  }
}

resource "awscc_ec2_transit_gateway_attachment" "tgw_attachment" {
  subnet_ids         = var.aws_private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.aws_vpc_id

  tags = [
    {
      key   = "Name"
      value = "${var.prefix}-tgw-attachment"
    }
  ]
}

resource "aws_vpn_connection" "vpn_conn" {
  count = var.num_tunnels / 2

  customer_gateway_id   = aws_customer_gateway.gwy[count.index % 2].id
  type                  = "ipsec.1"
  transit_gateway_id    = aws_ec2_transit_gateway.tgw.id
  tunnel1_preshared_key = var.shared_secret
  tunnel2_preshared_key = var.shared_secret

  tags = {
    Name = "${var.prefix}-vpn-conn"
  }
}

resource "aws_route" "vpn_route" {
  for_each = { for combo in setproduct(toset(var.aws_route_table_ids), toset(var.gcp_subnet_cidrs)) : "${combo[0]}-${combo[1]}" => combo }

  route_table_id            = each.value[0]
  destination_cidr_block    = each.value[1]
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
}

resource "aws_vpc_security_group_ingress_rule" "vpn_sg_rule" {
  for_each = { for combo in setproduct(toset(var.sg_ingress_port), toset(var.gcp_subnet_cidrs)) : "${combo[0]}-${combo[1]}" => combo }

  security_group_id = var.aws_security_group_id
  description       = "Security group rule to allow connection to AWS resources"
  cidr_ipv4         = each.value[1]
  from_port         = each.value[0]
  ip_protocol       = "tcp"
  to_port           = each.value[0]
}
