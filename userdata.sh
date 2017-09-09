#!/bin/bash
cd /tmp
echo "Installing Packages"
yum update -y
yum install -y httpd24 php56 php56-mysqlnd git
echo "Starting Apache"
service httpd start
echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
export NVM_DIR="/.nvm"
chmod 777 /.nvm/nvm.sh
source /.nvm/nvm.sh
nvm --version
echo "Installing NodeJS"
nvm install 8.4.0
echo "cloning honest2dog"
git -version
git clone https://github.com/dgsilcox/honest2dog.git
cd honest2dog
npm install
npm run build
sudo chown -R ec2-user:ec2-user /var/www/html
cp -R build/* /var/www/html
chkconfig httpd on