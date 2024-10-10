# Terraform AWS VPC Module Customised

This module is going to create following resources. For High availability we are going to get first 2 AZ

* VPC

. Internet Gateway associated with VPC

. 2 Public Subnets

. 2 Private Subnets

. 2 Database Subnets

. Elastic IP

. NAT Gatewaty

. Public Route Table

. Private Route Table

. Database Route Table

. Routes

. Route Table association with Subnets

. Peering with Default VPC (if required)

. Peering Routes in acceptor and requester Route Tables


## Inputs

. project_name (Mandatory): User must provide project name

. environment (Mandatory): User must provide environment name

. cidr_block (Mandatory): User must supply their VPC CIDR.

. enable_dns_hostnames (Optional): defaults to true.

. common_tags (Optional): Default is empty. User can supply tags in map(string) format.

. vpc_tags (Optional): Default is empty. User can supply tags in map(string) format.

. igw_tags (Optional): Default is empty. User can supply tags in map(string) format.

. public_cidr_blocks (Mandatory): User must supply only 2 valid public subnet CIDR.

. public_subnet_tags (Optional): Default is empty. User can supply tags in map(string) format.

. private_cidr_blocks (Mandatory): User must supply only 2 valid private subnet CIDR.

. private_subnet_tags (Optional): Default is empty. User can supply tags in map(string) format.

. database_cidr_blocks (Mandatory): User must supply only 2 valid database subnet CIDR.

. database_subnet_tags (Optional): Default is empty. User can supply tags in map(string) format.

. database_subnet_group_tags (Optional): Default is empty. User can supply tags in map(string) format.

. nat_gateway_tags (Optional): Default is empty. User can supply tags in map(string) format.

. public_route_table_tags (Optional): Default is empty. User can supply tags in map(string) format.

. private_route_table_tags (Optional): Default is empty. User can supply tags in map(string) format.

. database_route_table_tags (Optional): Default is empty. User can supply tags in map(string) format.

. is_peering_required (Optional): defaults to false

. vpc_peering_tags (Optional): Default is empty. User can supply tags in map(string) format.



## Outputs

. vpc_id: VPC ID created