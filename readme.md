# Newsletter Form
Newsletter form is a web application deployed on AWS that takes an input from the end user. The user inputs their name, email, and phone number on the website, and this info is stored in an AWS RDS. Another web server has been set up to view the database of users.

# Installation and Setup
## Prerequisites
* An AWS account
* [AWS CLI V2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Setup AWS CLI
In your terminal, type:
```
aws configure
```
Here is where you enter your credentials and configure AWS. 
1. Enter the Access Key ID and Secret Access key for your AWS account. You can also copy your credentials to `~/.aws/credentials`
2. Choose your default region. For the purposes of this tutorial, we have chosen us-east-1
3. For the default output format, use text

## Clone Repository
```
git clone https://github.com/harrypittar/NewsletterForm
```
and enter the directory:
```
cd NewsletterForm
```  

## Deployment
1. Create a default VPC for the application:
    ``` 
    aws ec2 create-default-vpc --query Vpc.VpcId
     ```

    and note down the output as *"VPC ID"* in `aws-ids.txt`

2. Create Security groups  
    Replace [VPC-ID] with your *VPC ID*:
    ```
    sed -i '' 's/vpc-12345/[VPC-ID]/g' create-security-groups.sh
    ```
    Create the security groups:
    ```
    sh create-security-groups.sh
    ```
    and note the first output as *"Web Server Security Group ID"* and the second output as *"Database Security Group ID"* in `aws-ids.txt`

3. Get remaining AWS IDs  
    Type the following commands and save each output to `aws-ids.txt`:
    <br><br>
    ```
    aws ec2 describe-subnets --filters "Name=availability-zone, Values=us-east-1a" --query "Subnets[*].SubnetId"
    ```
    as *"User Webserver Subnet ID"*,<br><br>

    ```
    aws ec2 describe-subnets --filters "Name=availability-zone, Values=us-east-1b" --query "Subnets[*].SubnetId"
    ```
    as *"Admin Webserver Subnet ID"*,<br><br>

    ```
    aws ec2 describe-subnets --filters "Name=availability-zone, Values=us-east-1c, us-east-1d" --query "Subnets[*].SubnetId"
    ```
    (two outputs) as *"RDS Subnet 1 ID"* and *"RDS Subnet 2 ID"*,<br><br>
    ```
    aws ec2 describe-instances --filters 'Name=tag:Name, Values=user-webserver' --query "Reservations[*].Instances[*].InstanceId"
    ```
    as *"User Webserver Instance ID"*,<br><br>
    ```
    aws sts get-caller-identity --query Account 
    ```
    and this output as *"Account ID"*.


4. Replace IDs in deployment script  
    Open `replace-ids.sh` in a text editor and replace each ID placeholder with your ID stored in `aws-ids.txt`<br><br>
    For example, on line 1 of `replace-ids.sh`, replace [WEBSERVER-SECURITY-GROUP-ID] with your *"Webserver Security Group ID"*.   
    <br>
    And replace IDs:
    ```
    sh replace-ids.sh
    ```
5. Deploy Application
    ```
    sh deploy.sh
    ```
6. Create and configure S3 bucket:  
    Replace [BUCKET-NAME] with a unique bucket name of your choice and store this name as *"Bucket Name"* in `aws-ids.txt`
    ```
    aws s3api create-bucket --bucket [BUCKET-NAME]
    ```
    
    Associate IAM profile with user webserver instance: replace [USER-WEBSERVER-INSTANCE-ID] with your *"User Webserver Instance ID"* in `aws-ids.txt`
    ```
    aws ec2 associate-iam-instance-profile --instance-id [USER-WEBSERVER-INSTANCE-ID] --iam-instance-profile Name=mys3bucketaccess
    ```
7. Create bucket access point:  
    Replace [ACCOUNT-ID], [BUCKET-NAME], and [VPC-ID] and run:
    ```
    aws s3control create-access-point --account-id [YOUR-ACCOUNT-ID] --bucket [YOUR-BUCKET-NAME] --name s3accesspoint --vpc-configuration 'VpcId=[VPC-ID]' --public-access-block-configuration 'BlockPublicAcls=FALSE,IgnorePublicAcls=FALSE,BlockPublicPolicy=FALSE,RestrictPublicBuckets=FALSE'
    ```


## Setup Webservers
1. Get the public DNS for your user webserver and store as *"User Webserver DNS"* in `aws-ids.txt`:
    ```
    aws ec2 describe-instances --filters "Name=tag:Name,Values=user-webserver" --query 'Reservations[].Instances[].PublicDnsName'
    ```
2. Get the public DNS for your admin webserver and store as *"Admin Webserver DNS"* in `aws-ids.txt`:  
    ```
    aws ec2 describe-instances --filters "Name=tag:Name,Values=admin-webserver" --query 'Reservations[].Instances[].PublicDnsName'
    ```
3. Get DB Instance endpoint and store as *"DB Instance Endpoint"* in `aws-ids.txt`:  

    ```
    aws rds describe-db-instances --query "DBInstances[].Endpoint.Address"
    ```
4. Edit dbinfo.inc:  
    Replace [DB-INSTANCE-ENDPOINT] in `dbinfo.inc` with your DB Instance Endpoint.
5. Set up web servers  
    Replace [USER-WEBSERVER-DNS] and [ADMIN-WEBSERVER-DNS] and run the following:
    ```
    sed -i '' 's/user-webserver.com/[USER-WEBSERVER-DNS]/g' setup-webservers.sh
    ```
    ```
    sed -i '' 's/admin-webserver.com/[ADMIN-WEBSERVER-DNS]/g' setup-webservers.sh
    ```
    ```
    sh setup-webservers.sh
    ```

## Usage
To view the user webserver page, visit your *"User Webserver DNS"* in your web browser, e.g.: ec2-3-236-198-221.compute-1.amazonaws.com <br><br>
To view the database of entries, visit your *"Admin Server DNS"*