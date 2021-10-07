# Allocate Elastic IP address
aws ec2 allocate-address

# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --no-amazon-provided-ipv6-cidr-block --query Vpc.VpcId --output text

# Create public subnet
aws ec2 create-subnet --vpc-id vpc-013d086fde1b98a32 --cidr-block 10.0.0.0/24 --availability-zone us-east-1a

# Create private subnets
aws ec2 create-subnet --vpc-id vpc-013d086fde1b98a32 --cidr-block 10.0.1.0/24 --availability-zone us-east-1b
aws ec2 create-subnet --vpc-id vpc-013d086fde1b98a32 --cidr-block 10.0.2.0/24 --availability-zone us-east-1c
