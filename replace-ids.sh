sed -i '' 's/sg-webserver/[WEBSERVER-SECURITY-GROUP-ID]/g' deploy.sh
sed -i '' 's/sg-database/[DATABASE-SECURITY-GROUP-ID]/g' deploy.sh
sed -i '' 's/subnet-user-webserver/[USER-WEBSERVER-SUBNET-ID]/g' deploy.sh
sed -i '' 's/subnet-admin-webserver/[ADMIN-WEBSERVER-SUBNET-ID]/g' deploy.sh
sed -i '' 's/subnet-rds-1/[RDS-SUBNET-1-ID]/g' deploy.sh
sed -i '' 's/subnet-rds-2/[RDS-SUBNET-2-ID]/g' deploy.sh