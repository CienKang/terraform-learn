output "tf_vpc" {
  value = aws_vpc.tf_vpc.id
}

output "tf_subnets" {
  value = {
    public  = aws_subnet.tf_public_subnet[*].cidr_block
    private = aws_subnet.tf_private_subnet[*].cidr_block
  }
}

output "tf_ig" {
  value = aws_internet_gateway.tf_ig.id
}

output "tf_public_route_table" {
  value = aws_route_table.tf_public_route_table.route
}

output "tf_private_route_table" {
  value = aws_route_table.tf_private_route_table.route
}

output "tf_public_rt_assoc" {
  value = aws_route_table_association.tf_public_rt_assoc[*].subnet_id
}
output "tf_private_rt_assoc" {
  value = aws_route_table_association.tf_private_rt_assoc[*].subnet_id
}
