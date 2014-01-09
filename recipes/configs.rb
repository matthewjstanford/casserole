#
# Cookbook Name:: casserole
# Recipe:: configs
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

service node["cassandra"]["name"]

conf_dir = File.expand_path(node["cassandra"]["conf_dir"])
cuser = node["cassandra"]["user"]
cgroup = node["cassandra"]["group"]
home_dir = File.expand_path(node["cassandra"]["home_dir"])

# If key_cache_size isn't set, set it according to the JVM heap size
#node.set_unless['cassandra']['config']['key_cache_size_in_mb'] = key_cache_size_mb

directory conf_dir do
  owner cuser
  group cgroup
  mode "0755"
  action :create
  recursive true
end

template "/etc/init.d/#{node["cassandra"]["name"]}" do
  owner "root"
  group "root"
  mode "0755"
  source "configs/cassandra.init.#{node["platform_family"]}.erb"
  variables(
    :service_name           => node["cassandra"]["name"],
    :home_dir               => node["cassandra"]["home_dir"],
    :conf_dir               => node["cassandra"]["conf_dir"],
    :user                   => node["cassandra"]["user"]
  )
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

template "#{conf_dir}/cassandra.in.sh" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra.in.sh.erb"
  action :create
  variables(
    :conf_dir => conf_dir,
    :home_dir => home_dir
  )
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

template "#{conf_dir}/cassandra.yaml" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra.yaml.erb"
  action :create
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

template "#{conf_dir}/cassandra-rackdc.properties" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra-rackdc.properties.erb"
  action :create
  variables(
    :datacenter         => node["cassandra"]["datacenter"] || node["cassandra"]["default_datacenter"],
    :rack               => node["cassandra"]["rack"] || node["cassandra"]["default_rack"],
    :datacenter_suffix  => node["cassandra"]["datacenter_suffix"] || "",
    :prefer_local       => node["cassandra"]["rackdc"]["prefer_local"] || false
  )
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

template "#{conf_dir}/cassandra-topology.properties" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra-topology.properties.erb"
  action :create
  variables(
    :nodes                => node["cassandra"]["cluster_nodes"],
    :default_datacenter   => node["cassandra"]["default_datacenter"],
    :default_rack         => node["cassandra"]["default_rack"]
  )
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

# Start the service if it isn't already up
service node["cassandra"]["name"] do
  action :start
  retries 2
end

execute 'sleep 30'

# Connect to the running cluster and change the name, if necessary
cassandra_alter_cluster_name node["cassandra"]['config']["cluster_name"] do
  listen_ip node['cassandra']['config']['listen_address']
  port node['cassandra']['config']['rpc_port'].to_s || "9160"
  action :run
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

