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

output "ami_id" {
  value = {
    id       = data.aws_ami.amazon_linux_2.id,
    image_id = data.aws_ami.amazon_linux_2.image_id

  }
}

output "tf_ssh_key_pair" {
  value = aws_key_pair.tf_ssh_key_pair.key_name

}

output "tf_ec2_instance" {
  value = {
    id        = aws_instance.tf_ec2_instance.id
    public_ip = aws_instance.tf_ec2_instance.public_ip,
    dns       = aws_instance.tf_ec2_instance.public_dns
  }
}
