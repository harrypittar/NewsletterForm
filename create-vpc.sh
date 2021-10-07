# Allocate Elastic IP address
aws ec2 allocate-address

# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --no-amazon-provided-ipv6-cidr-block --query Vpc.VpcId --output text

# Create public subnet
aws ec2 create-subnet --vpc-id vpc-013d086fde1b98a32 --cidr-block 10.0.0.0/24 --availability-zone us-east-1a

# Create private subnets
aws ec2 create-subnet --vpc-id vpc-013d086fde1b98a32 --cidr-block 10.0.1.0/24 --availability-zone us-east-1b
aws ec2 create-subnet --vpc-id vpc-013d086fde1b98a32 --cidr-block 10.0.2.0/24 --availability-zone us-east-1c

# Make subnet public
aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text
aws ec2 attach-internet-gateway --vpc-id vpc-013d086fde1b98a32 --internet-gateway-id igw-0524fe0d55672a5a4
aws ec2 create-route-table --vpc-id vpc-013d086fde1b98a32 --query RouteTable.RouteTableId --output text
aws ec2 create-route --route-table-id rtb-03260cc9d8ebf20d2 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0524fe0d55672a5a4
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-013d086fde1b98a32" --query "Subnets[*].{ID:SubnetId,CIDR:CidrBlock}"
aws ec2 associate-route-table  --subnet-id subnet-06b70225232ffec28 --route-table-id rtb-03260cc9d8ebf20d2

# Create VPC security group for public web server and enable public access
aws ec2 create-security-group --group-name webserver-securitygroup --description "Web Server Security Group" --vpc-id vpc-013d086fde1b98a32 --query GroupId --output text
aws ec2 authorize-security-group-ingress --group-id sg-08b0330628d780ffa --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-08b0330628d780ffa --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-08b0330628d780ffa --protocol tcp --port 443 --cidr 0.0.0.0/0
