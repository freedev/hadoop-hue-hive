#
# Cookbook Name:: hadoop-hue-hive
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# group 'hadoop'
group node['hadoop-hue-hive']['user']

user_home = "/home/#{node['hadoop-hue-hive']['user']}"

user node['hadoop-hue-hive']['group'] do
  group node['hadoop-hue-hive']['user']
  shell '/bin/bash'
  home user_home
  password '$1$RF0eUP9s$r.H4rcWvQ9zc5REJydT2c/'
  action :create
end

ssh_known_hosts_entry 'localhost'
