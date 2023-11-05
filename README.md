## Introduction

This is a proposal for connecting many VPCs in different AWS regions.


## Getting Started

1. Solution overview:
In this case, i use VPC Peering enables private connectivity between 2 VPCs, this connection provides high bandwidth with low latency and free cost.

2. Why I choose the solution
I have found some options to connect multiple VPCs from different regions. One is using Transit Gateway, the other is using VPC Peering. Using Transit Gateway is a great option, easy to scale, but it costs quite a lot to operate and the architecture is complex. So I decided to choose using VPC Peering.

3. Project overview:
This repo presents the solution using VPC Peering to connect 2 VPCs by Terraform, one in region us-east-1, the other in region us-west-1. Details of the solution are in the docs folder, IAC source codes are in the terraform folder.