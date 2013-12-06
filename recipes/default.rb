#
# Cookbook Name:: casserole
# Recipe:: default
#
# Copyright 2012, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "sysctl"
include_recipe "ntp"
include_recipe "#{@cookbook_name}::user"
include_recipe "#{@cookbook_name}::repos"
include_recipe "#{@cookbook_name}::packages"
include_recipe "java" # Java needs to be after packages, in case OpenJDK gets installed by the packages

if node["cassandra"]["clustered"] and node["cassandra"]["data_bag"]
  include_recipe "#{@cookbook_name}::data_bag_parser"
end
if node["cassandra"]["config"]["server_encryption_options"]["internode_encryption"] != "none"
  include_recipe "#{@cookbook_name}::encryption"
end
unless node['cassandra']['config']['num_tokens'] > 1
  if node["cassandra"]["clustered"] and !node["cassandra"]["config"]["initial_token"]
    include_recipe "#{@cookbook_name}::token_generator"
  end
end
include_recipe "#{@cookbook_name}::configs"

(node["cassandra"]["extra_services"]).each do |s|
  service s do
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end
