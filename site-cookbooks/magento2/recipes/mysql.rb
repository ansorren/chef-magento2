
execute "Install php5.6" do
    command "apt-get install -y mysql-client-core-5.6"
    action :run
end


mysql_service 'foo' do
  port '3306'
  version '5.6'
  server_root_password 'mysqlroot'
  action [:create, :restart]
end

