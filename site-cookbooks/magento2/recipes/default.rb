#
# Cookbook Name:: magento2
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]


  when "ubuntu"

    #  Install Composer
    execute "Install Curl" do
      command "apt-get install -y curl"
      action :run
    end

    #  Install Composer
    execute "Install Composer" do
      command "curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer"
      action :run
    end


    execute "Create /var/www/ dir if not exists" do
     command "mkdir -p /var/www/"
     action :run
    end


    # directory "/var/www/" do
    #   owner 'vagrant'
    #   group 'root'
    #   mode '777'
    #   recursive true
    # end

    #  Download Magento2 and Install Modules
    execute "Download Magento2" do
      command "if cd /var/www/magento2; then cd /var/www/magento2 && git pull; else cd /var/www/ && git clone  https://github.com/magento/magento2.git; fi "
      action :run
    end

    #  Download Magento2 and Install Modules
    execute "Composer Install" do
      command "cd /var/www/magento2 && composer install"
      action :run
    end

    #  Create Database
    execute "Create Database" do
      command 'echo "CREATE DATABASE if not exists magento2" | mysql -u root -pmysqlroot'
      action :run
    end

    execute "Install php5.6-mysql" do
      command 'apt-get install -y php5.6-mysql'
      action :run
    end


    execute "Setup" do
      command "cd /var/www/magento2  && php bin/magento setup:install --base-url=http://mage2.local/ \
--db-host=localhost --db-name=magento2 --db-user=root --db-password=mysqlroot \
--admin-firstname=Sagar --admin-lastname=Bhandari --admin-email=sagar.bhandari@zipmoney.com.au \
--admin-user=admin --admin-password=admin123 --language=en_US \
--currency=AUD --timezone=America/Chicago --use-rewrites=1"
      action :run
    end

    execute "Set Permissions" do
      command "cd /var/www/magento2  &&  chmod -R 777 var/* pub/* app/*"
      action :run
    end

    execute "Upgrade" do
      command "cd /var/www/magento2 && php bin/magento setup:upgrade "
      action :run
    end

    execute "Sample Data" do
     command "cd /var/www/html && php bin/magento setup:upgrade"
     action :run
    end

  end