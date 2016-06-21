case node[:platform]
    
    when "amazon"
    # node.set['php']['packages'] = ['php55w', 'php55w-devel', 'php55w-cli', 'php55w-snmp', 'php55w-soap', 'php55w-xml', 'php55w-xmlrpc', 'php55w-process', 'php55w-mysqlnd', 'php55w-pecl-memcache', 'php55w-opcache', 'php55w-pdo', 'php55w-imap', 'php55w-mbstring']
    node.set['mysql']['server']['packages'] = %w{mysql55-server}
    node.set['mysql']['client']['packages'] = %w{mysql55}
    
    # add the webtatic repository
    yum_repository "webtatic" do
        repo_name "webtatic"
        description "webtatic Stable repo"
        url "http://repo.webtatic.com/yum/el6/x86_64/"
        key "RPM-GPG-KEY-webtatic-andy"
        action :add
    end
    
    yum_key "RPM-GPG-KEY-webtatic-andy" do
        url "http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-andy"
        action :add
    end
    
    
    # remove any existing php/mysql
    execute "yum remove -y php* mysql*"
    
    # get the metadata
    execute "yum -q makecache"
    
    # manually install php 5.5....
    execute "yum install -y --skip-broken php55w php55w-devel php55w-cli php55w-snmp php55w-soap php55w-xml php55w-xmlrpc php55w-process php55w-mysqlnd php55w-pecl-memcache php55w-opcache php55w-pdo php55w-imap php55w-mbstring"

  when "rhel", "fedora", "suse", "centos"
  # add the webtatic repository
  yum_repository "webtatic" do
    repo_name "webtatic"
    description "webtatic Stable repo"
    url "http://repo.webtatic.com/yum/el6/x86_64/"
    key "RPM-GPG-KEY-webtatic-andy"
    action :add
  end

  yum_key "RPM-GPG-KEY-webtatic-andy" do
    url "http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-andy"
    action :add
  end
  
  node.set['php']['packages'] = ['php55w', 'php55w-devel', 'php55w-cli', 'php55w-snmp', 'php55w-soap', 'php55w-xml', 'php55w-xmlrpc', 'php55w-process', 'php55w-mysqlnd', 'php55w-pecl-memcache', 'php55w-opcache', 'php55w-pdo', 'php55w-imap', 'php55w-mbstring']
  node.set['mysql']['server']['packages'] = %w{mysql55-server}
  node.set['mysql']['client']['packages'] = %w{mysql55}
  
  include_recipe "php"

  when "ubuntu"

    package "python-software-properties" do
        action :install
    end

    apt_repository "php5-5.6" do
        uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
        distribution node["lsb"]["codename"]
        components ["main"]
        keyserver "keyserver.ubuntu.com"
        key "E5267A6C"
    end

    # Manually install php55 to avoid the permission error using chefs package install.
    execute "Install php55" do 
      command "apt-get update -y && apt-get install -y php5"
      action :run
    end

    # Install all our lovely modules!
    %w[php5-mysql php5-curl php5-gd php-pear php5-imagick php5-imap php5-mcrypt php5-memcached php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xcache].each do |name|
      package name
    end

  when "debian"
    include_recipe "apt"
	apt_repository "wheezy-php55" do
		uri "#{node['php55']['dotdeb']['uri']}"
		distribution "#{node['php55']['dotdeb']['distribution']}-php55"
		components ['all']
		key "http://www.dotdeb.org/dotdeb.gpg"
		action :add
	end
	
	  include_recipe "php"
  end