cd /var/www/html/

if [ -f inventory.html ]; then

echo "inventory.html exists "
else

echo -e "Log Type\t\tDate Created \t\t Type \t\t Size " > /var/www/html/inventory.html

fi

sudo apt update -y
apache_present=$(dpkg -l apache2|grep ii|wc -l)

if  [ $apache_present -eq 0 ]
then
sudo apt install apache2
fi

sudo systemctl start apache2
timestamp=$(date '+%d%m%Y-%H%M%S')
myname="Priyesh"
s3_bucket="upgrad-priyesh"

tar -cvf /tmp/$myname-httpd-logs-$timestamp.tar /var/log/apache2/*.log
size=$(du -sh /tmp/$myname-httpd-logs-$timestamp.tar |awk '{print $1}')
echo -e "httpd-logs\t\t$timestamp \t\t tar \t\t $size" >>/var/www/html/inventory.html



aws s3 \cp /tmp/${myname}-httpd-logs-${timestamp}.tar \s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
cd /etc/cron.d/
if [ ! -f automation.sh ];then
echo "5 4 * * * root /root/Automation_Project/automation.sh" >/etc/cron.d/automation
fi
