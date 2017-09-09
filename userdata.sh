#!/bin/bash
cd /tmp
echo "Installing Packages"
yum update -y
yum install -y httpd24 php56 php56-mysqlnd git

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
export NVM_DIR="/.nvm"
chmod 777 /.nvm/nvm.sh
source /.nvm/nvm.sh
nvm --version

echo "Installing NodeJS and NPM"
nvm install 8.4.0

echo "Cloning and building honest2dog"
git -version
git clone https://github.com/dgsilcox/honest2dog.git
cd honest2dog
npm install
npm run build

echo "Deploying Honest2Dog to /var/www/html"
sudo chown -R ec2-user:ec2-user /var/www/html
cp -R build/* /var/www/html

echo "Modify Apache conf"
awk -v "n=157" -v "s=RewriteEngine on
RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule ^ index.html [L]" '(NR==n) { print s } 1' /etc/httpd/conf/httpd.conf > /tmp/httpd.conf
mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
mv /tmp/httpd.conf /etc/httpd/conf/httpd.conf

echo "Starting Apache"
service httpd start
chkconfig httpd on