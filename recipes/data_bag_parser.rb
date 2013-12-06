#
# Cookbook Name:: casserole
# Recipe:: data_bag_parser
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

# Combine data bag settings with ones provided in the attributes phase
# to create a full attribute set for this node.

cluster_conf = data_bag_item(node["cassandra"]["data_bag"], node["cassandra"]["config"]["cluster_name"])
node.default["cassandra"]["cluster_nodes"] = cluster_conf["nodes"]

# Extract the information about the node from the cluster
node_conf = cluster_conf["nodes"][node["cassandra"]["node_id"]]
if !node_conf
  raise Chef::Exceptions::ConfigurationError,
    "Node was not defined in the cluster config"
end

# Allow data bag entries to take precedence over default attributes
node_conf['config'].each do |k,v|
  node.default["cassandra"]["config"][k] = v 
end
%w{endpoint_snitch num_tokens}.each do |a|
  node.default["cassandra"]["config"][a] = cluster_conf[a] if cluster_conf[a]
end
%w{datacenter rack}.each do |a|
  node.default["cassandra"][a] = node_conf[a] if node_conf[a]
end
%w{datacenter_suffix}.each do |a|
  node.default["cassandra"][a] = cluster_conf[a] if cluster_conf[a]
end

# Determine the seed nodes, sorted so the list is the same across the cluster
a = []
cluster_conf["nodes"].each do |k, v|
  a << v['config']["broadcast_address"] if v["seed"]
end
if a.empty?
  raise Chef::Exceptions::ConfigurationError, "Seed list cannot be empty"
end

node.default['cassandra']['config']['seed_provider'][0]['parameters'][0]['seeds'] = a.compact.sort.join(',')

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
