#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright (C) 2014 Vincenzo D'Amore v.damore@gmail.com
#
# All rights reserved - Do Not Redistribute
#

require 'uri'

hadoop_user = node['hadoop']['user']
hadoop_group = node['hadoop']['group']
hadoop_user_home = "/home/#{hadoop_user}"
hive_url = node['hive']['url_src']
hive_uri = URI.parse(hadoop_url)
hive_filename = File.basename(hadoop_uri.path)
hive_basename = File.basename(hadoop_uri.path, '.tar.gz')
basedir = '/usr/local'
hive_basedir = "#{basedir}/#{hive_basename}"
hive_home = "#{basedir}/hive"

remote_file "/tmp/#{hive_filename}" do
  source hive_url
end

execute "tar-xzf-hive" do
  user "root"
  command "tar xzf /tmp/#{hive_filename}"
  action :run
  cwd basedir
  returns 0
  not_if { ::File.exists?(hive_basedir) }
end

directory hive_basedir do 
  owner hadoop_user
  group hadoop_group
end

execute "ln-s-#{hive_basename}" do
  user "root"
  command "ln -s #{hive_basedir} #{hive_home}"
  action :run
  cwd basedir
  returns 0
  not_if { ::File.exists?(hive_home) }
end

execute "modify-bashrc" do
  user hadoop_user
  group hadoop_group
  command ". #{hadoop_user_home}/.bashrc && #{hive_home}/bin/hiveserver2"
  action :run
  cwd hive_home
  environment ({'HOME' => hadoop_user_home, 'USER' => hadoop_user})
  returns 0
end

