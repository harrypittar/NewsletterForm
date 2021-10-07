aws ec2 describe-security-groups

# Create DB instance
aws rds create-db-instance \
    --engine mysql \
    --db-instance-identifier mysql-instance \
    --master-username admin \
    --master-user-password password \
    --db-instance-class db.t2.micro \
    --db-subnet-group-name db-subnetgroup \
    --no-publicly-accessible \
    --vpc-security-group-ids sg-0d8a441084eba7d5c \
    --allocated-storage 20 \
    --db-name subscribers
