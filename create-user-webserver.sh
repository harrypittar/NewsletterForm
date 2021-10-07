# Create key pair
aws ec2 create-key-pair --key-name aws-keypair --query 'KeyMaterial' --output text > ~/.ssh/aws-keypair.pem

# View subnets
aws ec2 describe-subnets

# View securiy groups
aws ec2 describe-security-groups

# Create EC2 Instance
aws ec2 run-instances \
    --image-id ami-09e67e426f25ce0d7 \
    --instance-type t2.micro \
    --key-name aws-keypair \
    --subnet-id subnet-06b70225232ffec28 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=web-server}]' \
    --security-group-ids sg-08b0330628d780ffa \
    --associate-public-ip-address
