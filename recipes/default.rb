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
user_home = "/home/#{hadoop_user}"
hadoop_url = node['hadoop-hue-hive']['url_src']
hadoop_uri = URI.parse(hadoop_url)
hadoop_filename = File.basename(hadoop_uri.path)
hadoop_basename = File.basename(hadoop_uri.path, '.tar.gz')
basedir = '/usr/local'
hadoop_basedir = "#{basedir}/#{hadoop_basename}"

group hadoop_group

user hadoop_user do
  group hadoop_group
  shell '/bin/bash'
  home user_home
  password '$1$RF0eUP9s$r.H4rcWvQ9zc5REJydT2c/'
  action :create
end

ssh_known_hosts_entry 'localhost'

puts "Downloading #{hadoop_url} into #{hadoop_basedir}"

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
  group
end
