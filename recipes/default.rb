#
# Cookbook Name:: hadoop-hue-hive
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

group 'hadoop'

user 'hduser' do
  group 'hadoop'
  shell '/bin/bash'
  home '/home/hduser'
  password '$1$RF0eUP9s$r.H4rcWvQ9zc5REJydT2c/'
  action :create
end

ssh_known_hosts_entry 'localhost'
