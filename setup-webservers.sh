ssh -i "~/.ssh/aws-keypair.pem" ec2-user@user-webserver.com 'bash -s' < install-apache.sh
ssh -i "~/.ssh/aws-keypair.pem" ec2-user@user-webserver.com 'bash -s' < update-apache-permissions.sh
ssh -i "~/.ssh/aws-keypair.pem" ec2-user@admin-webserver.com 'bash -s' < install-apache.sh
ssh -i "~/.ssh/aws-keypair.pem" ec2-user@admin-webserver.com 'bash -s' < update-apache-permissions.sh
scp -i "~/.ssh/aws-keypair.pem" dbinfo.inc ec2-user@user-webserver.com:/var/www/inc
scp -i "~/.ssh/aws-keypair.pem" dbinfo.inc ec2-user@admin-webserver.com:/var/www/inc
scp -i "~/.ssh/aws-keypair.pem" Form.php ec2-user@user-webserver.com:/var/www/html
scp -i "~/.ssh/aws-keypair.pem" Data.php ec2-user@admin-webserver.com:/var/www/html