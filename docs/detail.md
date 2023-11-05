## Solution

![diagram](https://github.com/quangtung20/demo_interview/assets/79434671/b42746c3-18ad-4622-b20f-e4eb0e7653d7)

The infrastructure created by Terraform, overview about the project:

VPC 1 (us-east-1):

- internet gateway for VPC A (support to connect inside EC2 instance)
- route table to connect subnet to igw and vpc peering
- public subnet
- private subnet
  + EC2 instance

VPC 2 (us-west-1):

- internet gateway for VPC B (support to connect inside EC2 instance)
- route table to connect subnet to igw and vpc peering
- public subnet
- private subnet
  + EC2 instance

VPC peering connection

- VPC Attachments to connect both VPCs to VPC peering
- Route Tables in each VPC routing traffic to VPC peering

Backend

- s3 bucket
- dynamo db

Detail terraform project: [Terraform](/terraform)

## How to run terraform project:
1.  Clone the repo
2.  Open repo and run: cd terraform
3.  Run: terraform init
4.  Update resources and run: terraform apply --auto-approve

## Reason why I choose using vpc peering
- Simple and fast to set up - The connection between VPCs can be easily established.
- Cost effective - VPC Peering has no usage fees unlike other interconnect options.
- Secure - All traffic between peered VPCs is encrypted.
- Private networking - VPCs appear as if they are within the same network.
- High bandwidth - VPC Peering provides high bandwidth capacity between VPCs.
- Low latency - Data transfer between VPCs is optimized for low latency.
- No single point of failure - VPC Peering connections are redundant in each AZ.
- Easy to scale - It's simple to add more peered connections as needed.

In summary, VPC Peering offers a straightforward way to enable private, high-speed connectivity between VPCs that is secure, robust and cost-efficient.

## How to test
1. connecting inside EC2 instance in each VPC
2. Use curl to connect to the EC2 instance of the other VPC to test the connection

## final result:
VPC 1 to VPC 2:

![image](https://github.com/quangtung20/demo_interview/assets/79434671/38529306-e6c7-4e4b-a7dc-6c5680c3ee8e)

VPC 2 to VPC 1:

![image](https://github.com/quangtung20/demo_interview/assets/79434671/873299c3-3d1c-437f-9f9d-1392dfcb6b3d)
