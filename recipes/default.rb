#
# Cookbook Name:: hadoop-hue-hive
# Recipe:: default
#
# Copyright (C) 2014 Vincenzo D'Amore v.damore@gmail.com
#
# All rights reserved - Do Not Redistribute
#

require 'uri'

hadoop_user = node['hadoop-hue-hive']['user']
hadoop_group = node['hadoop-hue-hive']['group']
hadoop_user_home = "/home/#{hadoop_user}"
hadoop_url = node['hadoop-hue-hive']['url_src']
hadoop_uri = URI.parse(hadoop_url)
hadoop_filename = File.basename(hadoop_uri.path)
hadoop_basename = File.basename(hadoop_uri.path, '.tar.gz')
basedir = '/usr/local'
hadoop_basedir = "#{basedir}/#{hadoop_basename}"
hadoop_home = "#{basedir}/hadoop"

group hadoop_group

user hadoop_user do
  group hadoop_group
  shell '/bin/bash'
  home hadoop_user_home
  supports :manage_home => true
  password '$1$RF0eUP9s$r.H4rcWvQ9zc5REJydT2c/'
  action :create
end

puts "Adding localhost to #{hadoop_user_home}/.ssh/known_hosts"

ssh_known_hosts_entry 'localhost'


remote_file "/tmp/#{hadoop_filename}" do
  source hadoop_url
end

execute "tar-xzf-hadoop" do
  user "root"
  command "tar xzf /tmp/#{hadoop_filename}"
  action :run
  cwd basedir
  returns 0
  not_if { ::File.exists?(hadoop_basedir) }
end

directory hadoop_basedir do 
  owner hadoop_user
  group hadoop_group
end

execute "ln-s-#{hadoop_basename}" do
  user "root"
  command "ln -s #{hadoop_basedir} #{hadoop_home}"
  action :run
  cwd basedir
  returns 0
  not_if { ::File.exists?(hadoop_home) }
end

template "#{hadoop_user_home}/hadoop_bashrc" do
  source "hadoop_bashrc.erb"
  action :create
end

execute "modify-bashrc" do
  user "root"
  command "cat #{hadoop_user_home}/hadoop_bashrc >> #{hadoop_user_home}/.bashrc"
  action :run
  cwd basedir
  returns 0
  not_if "grep -q HADOOP_HOME #{hadoop_user_home}/.bashrc"
end

directory "/app/hadoop/tmp" do
  owner hadoop_user
  group hadoop_group
  mode '0775'
  action :create
  recursive true
end

template "#{hadoop_home}/etc/hadoop/core-site.xml" do
  source "core-site.xml.erb"
  action :create
end

template "#{hadoop_home}/etc/hadoop/mapred-site.xml" do
  source "mapred-site.xml.erb"
  action :create
end

template "#{hadoop_home}/etc/hadoop/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  action :create
end

execute "modify-bashrc" do
  user "root"
  command "#{hadoop_home}/bin/hadoop namenode -format"
  action :run
  cwd basedir
  returns 0
end

