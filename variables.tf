variable "cidr_block" {
    type = string
    
}

variable "common_tags" {
    default = {}
}

variable "vpc_tags" {
    default = {}
}

variable "enable_dns_name" {
    default = true
}

variable "project_name" {

}

variable "environment" {

}

variable "igw_tags" {
    default = {}
}

variable "public_cidr_blocks" {
    type = list(string)    
    validation {
        condition = length(var.public_cidr_blocks) == 2
        error_message = "Please provide two valid public subnet"
    }
}

variable "public_subnet_tags" {
    default = {}
}

variable "private_cidr_blocks" {
    type = list(string)    
    validation {
        condition = length(var.private_cidr_blocks) == 2
        error_message = "Please provide two valid private subnet"
    }
}

variable "private_subnet_tags" {
    default = {}
}

variable "database_cidr_blocks" {
    type = list(string)    
    validation {
        condition = length(var.database_cidr_blocks) == 2
        error_message = "Please provide two valid database subnet"
    }
}

variable "database_subnet_tags" {
    default = {}
}

variable "database_subnet_group_tags" {
    default = {}
}

variable "nat_gateway_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
    default = {}
}

variable "dest_cidr_block" {
    
}

variable "is_peering_required" {
    type = bool
}

variable "vpc_peering_tags" {
    default = {}
}



