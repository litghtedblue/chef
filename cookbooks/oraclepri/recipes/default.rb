user "oracle" do
  home "/home/oracle"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
  action :create
end

group "oinstall" do
  members ['oracle']
  action :create
end


group "oinstall" do
  action :modify
  members ['oracle']
end

group "dba" do
  members ['oracle']
  action :create
end

group "dba" do
  action :modify
  members ['oracle']
end


group "oper" do
  members ['oracle']
  action :create
end


group "oper" do
  action :modify
  members ['oracle']
end

directory '/u01' do
  owner 'oracle'
  group 'oinstall'
  mode '0755'
  action :create
end

template "/home/oracle/.bash_profile" do
  source "bash_profile.erb"
  mode  0644
  owner "oracle"
  group "oracle"
  action :create
end


template "/etc/security/limits.conf" do
  source "limits.conf.erb"
  mode  0644
  owner "root"
  group "root"
  action :create
end

package 'my packages' do
  package_name [ 'tigervnc-server','gcc','ksh','glibc-devel','libstdc++','gcc-c++','libaio-devel','compat-libstdc++-33','compat-libcap1']
  provider Chef::Provider::Package::Yum
  action :install
end

execute 'unzip' do
  command 'unzip linuxamd64_12102_database_1of2.zip;unzip linuxamd64_12102_database_2of2.zip;chown oracle:oinstall /tmp/database;mv /tmp/database /home/oracle'
  cwd '/tmp'
  only_if { File.exists?("/tmp/linuxamd64_12102_database_1of2.zip") }
end


node.default['jenkins']['master']['install_method']='package'
include_recipe 'jenkins::master'

