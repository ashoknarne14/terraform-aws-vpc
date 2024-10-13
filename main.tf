resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = var.enable_dns_name

  tags = merge(
            var.common_tags,
            var.vpc_tags,
            {
                Name = local.resource_name
            }
        )
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
            var.common_tags,
            var.igw_tags,
            {
                Name = local.resource_name
            }
        )
}

resource "aws_subnet" "public" {
  count = length(var.public_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_blocks[count.index]
  availability_zone = local.az_name[count.index]
  map_public_ip_on_launch = true

  tags = merge(
            var.common_tags,
            var.public_subnet_tags,
            {
                Name = "${local.resource_name}-public-${local.az_name[count.index]}"
            }
        )
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_blocks[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(
            var.common_tags,
            var.private_subnet_tags,
            {
                Name = "${local.resource_name}-private-${local.az_name[count.index]}"
            }
        )
}

resource "aws_subnet" "database" {
  count = length(var.database_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_blocks[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(
            var.common_tags,
            var.database_subnet_tags,
            {
                Name = "${local.resource_name}-database-${local.az_name[count.index]}"
            }
        )
}

# database subnet group for RDS
resource "aws_db_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
            var.common_tags,
            var.database_subnet_group_tags,
            {
                Name = local.resource_name
            }
        )
}

resource "aws_eip" "nat" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
            var.common_tags,
            var.nat_gateway_tags,
            {
                Name = local.resource_name
            }
        )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
            var.common_tags,
            var.public_route_table_tags,
            {
                Name = "${local.resource_name}-public"
            }
        ) 
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
            var.common_tags,
            var.private_route_table_tags,
            {
                Name = "${local.resource_name}-private"
            }
        ) 
}

# database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
            var.common_tags,
            var.database_route_table_tags,
            {
                Name = "${local.resource_name}-database"
            }
        ) 
}

# public subnets and route table associations
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# private subnets and route table associations
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# database subnets and route table associations
resource "aws_route_table_association" "database" {
  count = length(var.database_cidr_blocks)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

# route for public route table
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.dest_cidr_block
  gateway_id = aws_internet_gateway.main.id
}

# route for private route table
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.dest_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}

# route for database route table
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = var.dest_cidr_block
  nat_gateway_id = aws_nat_gateway.main.id
}







