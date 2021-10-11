# Add Inbound Rules to Security Groups
aws ec2 authorize-security-group-ingress --group-id sg-webserver --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-webserver --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-database --protocol tcp --port 3306 --source-group sg-webserver

# Create Key Pair
aws ec2 create-key-pair --key-name aws-keypair --query 'KeyMaterial' --output text > ~/.ssh/aws-keypair.pem

# Create User Webserver
aws ec2 run-instances \
    --image-id ami-02e136e904f3da870 \
    --instance-type t2.micro \
    --key-name aws-keypair \
    --subnet-id subnet-user-webserver \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=user-webserver}]' \
    --security-group-ids sg-webserver \
    --associate-public-ip-address

# Create Admin Webserver
aws ec2 run-instances \
    --image-id ami-02e136e904f3da870 \
    --instance-type t2.micro \
    --key-name aws-keypair \
    --subnet-id subnet-admin-webserver \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=admin-webserver}]' \
    --security-group-ids sg-webserver \
    --associate-public-ip-address

# Create RDS Subnet Group
aws rds create-db-subnet-group \
--db-subnet-group-name db-subnetgroup \
--db-subnet-group-description "DB Subnet Group" \
--subnet-ids '["subnet-rds-1","subnet-rds-2"]'

# Create RDS Instance
aws rds create-db-instance \
    --engine mysql \
    --db-instance-identifier mysql-instance \
    --master-username admin \
    --master-user-password password \
    --db-instance-class db.t2.micro \
    --db-subnet-group-name db-subnetgroup \
    --no-publicly-accessible \
    --vpc-security-group-ids sg-database \
    --allocated-storage 20 \
    --db-name subscribers

# Modify Key Pair File Permissions
chmod 400 ~/.ssh/aws-keypair.pem