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

directory conf_dir do
  owner cuser
  group cgroup
  mode "0755"
  action :create
  recursive true
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

template "#{conf_dir}/cassandra-env.sh" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra-env.sh.erb"
  action :create
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

service node["cassandra"]["name"] do
  action :start
end

# Connect to the running cluster and change the name, if necessary
cassandra_alter_cluster_name node["cassandra"]['config']["cluster_name"] do
  listen_ip node['cassandra']['config']['listen_address']
  port "9160"
  action :run
end

template "#{conf_dir}/cassandra.yaml" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra.yaml.erb"
  action :create
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

my_dc = node["cassandra"]["datacenter"]
my_dc || my_dc = node["cassandra"]["default_datacenter"]
my_rack = node["cassandra"]["rack"] || node["cassandra"]["default_rack"]
template "#{conf_dir}/cassandra-rackdc.properties" do
  owner cuser
  group cgroup
  mode "0755"
  source "configs/cassandra-rackdc.properties.erb"
  action :create
  variables(
    :datacenter => my_dc,
    :rack => my_rack
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
    :nodes => node["cassandra"]["cluster_nodes"],
    :default_datacenter => node["cassandra"]["default_datacenter"],
    :default_rack => node["cassandra"]["default_rack"]
  )
  notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
end

#script "alter_cluster_name" do
  #interpreter 'ruby'
  #user "root"
#
  #db = CassandraCQL::Database.new("#{node['cassandra']['config']['listen_address']}:9160", { :keyspace => "system" })
  #db.execute("UPDATE local SET cluster_name = '#{node["cassandra"]['config']["cluster_name"]}' where key = 'local'")
#
  #only_if do
    #db = CassandraCQL::Database.new("#{node['cassandra']['config']['listen_address']}:9160", { :keyspace => "system" })
    #colfam = "local"
    #name = db.execute("SELECT * FROM #{colfam} WHERE KEY = 'local'").fetch["cluster_name"]
    #name != node["cassandra"]["cluster_name"]
  #end
#
  #action :nothing
  #notifies :run, "script[flush]", :immediate 
#end

#script "flush" do
  #interpreter "bash"
  #user "root"
  #code "nodetool flush"
  #action :nothing
#end


# Clear the system LocationInfo to force a cluster_name change
#script "alter_cluster_name_1" do
  #interpreter "bash"
  #user "root"
  #code "echo \"update local set cluster_name = '#{node["cassandra"]['config']["cluster_name"]}' where key = 'local';\" | cqlsh -k system; nodetool flush;"
  #not_if "echo \"select cluster_name from local where key = 'local';\" | cqlsh -k system | grep \"#{node["cassandra"]['config']["cluster_name"]}\""
  #notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
#end
#
#script "alter_cluster_name_2" do
  #interpreter "bash"
  #user "root"
  #code "echo \"update local set cluster_name = '#{node["cassandra"]['config']["cluster_name"]}' where key = 'local';\" | cqlsh -k system #{node['cassandra']['config']['listen_address']}; nodetool flush;"
  #not_if "echo \"select cluster_name from local where key = 'local';\" | cqlsh -k system #{node['cassandra']['config']['listen_address']} | grep \"#{node["cassandra"]['config']["cluster_name"]}\""
  #notifies :restart, "service[#{node["cassandra"]["name"]}]", :delayed
#end
#
# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
