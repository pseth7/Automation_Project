sudo apt update -y
apache_present=$(dpkg -l apache2|grep ii|wc -l)

if [ $apache_present -eq 0 ]
then
sudo apt install apache2
fi

systemctl enable apache2
sudo systemctl start apache2
timestamp=$(date '+%d%m%Y-%H%M%S')

tar -cvf /tmp/Priyesh-httpd-logs-$timestamp.tar /var/log/apache2/*.log

myname="Priyesh"

s3_bucket="upgrad-priyesh"
aws s3 \cp /tmp/${myname}-httpd-logs-${timestamp}.tar \s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
