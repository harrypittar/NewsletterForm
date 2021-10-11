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
1. Enter the Access Key ID and Secret Access key for your AWS account.
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
    and (two outputs) as *"RDS Subnet 1 ID"* and *"RDS Subnet 2 ID"*

4. Replace IDs in deployment script  
    Open `replace-ids.sh` in a text editor and replace each ID placeholder with your ID stored in `aws-ids.txt`<br><br>
    For example, on line 1 of `replace-ids.sh`, replace [WEBSERVER-SECURITY-GROUP-ID] with your *"Webserver Security Group ID"*.   
    <br>
    And replace IDs:
    ```
    sh replace-ids.sh
    ```
5. Deploy the application
    ```
    sh deploy.sh
    ```