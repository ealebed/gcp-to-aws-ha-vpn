# GCP-to-AWS High Availability VPN Module
This Terraform module establishes a high-availability VPN connection between GCP (Google Cloud Platform) and AWS (Amazon Web Services). It sets up redundant VPN tunnels for improved reliability and resilience.

## 1. Requirements
Before using this module, ensure that the following prerequisites are met:

- Terraform version: Ensure you are using Terraform version >= 0.13.
- AWS and GCP Credentials: You need valid credentials for both AWS and GCP.
- GCP Project ID: The GCP project where the resources will be created.
- AWS VPC Configuration: The AWS VPC ID, VPC CIDR block, VPC private subnets, route tables and security group must be specified.
- GCP Network: A valid GCP network and subnet CIDRs must be provided for the VPN gateway in GCP.

## 2. Description of Variables
### GCP Configuration:

- `project_id`: Specifies the GCP project where the VPN gateway and related resources will be deployed.
- `gcp_network`: The name of the GCP network to which the VPN gateway will be attached.
- `gcp_subnet_cidrs`: The list of CIDR block of the GCP subnets that will be used for the VPN gateway.
- `gcp_router_asn`: The ASN for the GCP VPN router.

### AWS Configuration:

- `aws_vpc_id`: The AWS VPC ID where the VPN connection will terminate.
- `aws_vpc_cidr`: The CIDR block of the AWS VPC that will be routed through the VPN.
- `aws_private_subnets`: List of private subnet IDs in AWS that will be routed through the VPN.
- `aws_security_group_id`: The security group in AWS that should allow VPN traffic.
- `aws_router_asn`: The ASN for the AWS VPN router.
- `aws_route_table_ids`: The list of route table IDs in AWS where routes for the VPN tunnels will be added.

### Shared Secret:

- `shared_secret`: The shared secret is used for VPN authentication. Make sure both GCP and AWS use the same secret.
> Shared secret can only contain alphanumeric, period and underscore characters

### VPN Tunnel Configuration:

- `num_tunnels`: The number of VPN tunnels to set up. This must be an even number and at least 4 to ensure high availability across multiple zones.

### Prefix:

- `prefix`: This is used to name all resources created by the module, helping to keep resources organized and easily identifiable.

## 3. Export AWS credentials into environment variables
```bash
export AWS_ACCESS_KEY_ID="aws-access-key-id"
export AWS_SECRET_ACCESS_KEY="aws-secret-access-key"
export AWS_REGION="us-east-1"
```

## 4. Login to gcp
```bash
gcloud auth application-default login
```

## 5. Deployment
```bash
terraform init -backend-config=bucket=<State Bucket Name>
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```
