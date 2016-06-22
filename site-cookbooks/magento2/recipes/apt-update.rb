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

    execute "Update" do 
      command "apt-get update -y && apt-get upgrade -y"
      action :run
    end

  end