aws ec2 create-security-group \
    --group-name webserver-securitygroup \
    --description "Web Server Security Group" \
    --vpc-id vpc-12345 \
    --query GroupId

aws ec2 create-security-group \
    --group-name db-securitygroup \
    --description "DB Security Group" \
    --vpc-id vpc-12345 \
    --query GroupId
