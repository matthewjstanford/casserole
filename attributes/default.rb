#
# Cookbook Name:: casserole
# Attributes:: default
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

# Override OpenJDK to Oracle Java instead
override["java"]["install_flavor"] = "oracle"
override["java"]["oracle"]["accept_oracle_download_terms"] = true
override['java']['jdk_version'] = "7"

default["cassandra"]["java"]["MAX_HEAP_SIZE"] = nil # set to '4G' or whatever to override the logic in the cassandra-env file
default["cassandra"]["java"]["HEAP_NEWSIZE"]  = nil # set to '4G' or whatever to override the logic in the cassandra-env file

default["cassandra"]["clustered"]   = false
default["cassandra"]["data_bag"]    = nil
default["cassandra"]["node_id"]     = node["fqdn"]

default["cassandra"]["nodetool_rebuild"] = false # Perform a "nodetool rebuild" after this chef run

# User settings
default["cassandra"]["name"]              = "cassandra"
default["cassandra"]["user"]              = "cassandra"
default["cassandra"]["group"]             = "cassandra"
default["cassandra"]["home_dir"]          = "/usr/share/cassandra"

default["cassandra"]["build_packages"] = []

default["cassandra"]["packages"] = {
    "python-cql" => { "version" => "1.4.0-2" },
    "dsc21" => { "version" => "2.1.2-1" },
    "datastax-agent" => {"version" => "5.0.2-1"},
}
default['cassandra']['remove_packages'] = %w(dsc1.1 dsc12 dsc20 cassandra1.1 cassandra12 cassandra20)
default["cassandra"]["remote_files"] = {
#    "jna" => {"source"      => "https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna/4.1.0/jna-4.1.0.jar",
#              "destination" => File.join(node["cassandra"]["home_dir"],'/lib/','jna-4.1.0.jar')},
}
  
default["cassandra"]["chef_gems"] = {
}

default["cassandra"]["extra_services"] = ["datastax-agent"]

default["cassandra"]["opscenter"]["packages"] = {
    "opscenter-free" => { "version" => "3.2.2-1"},
}
default["cassandra"]["opscenter"]["port"] = 8888
default["cassandra"]["opscenter"]["ipaddress"] = "0.0.0.0"

# Cluster definition attributes can be overridden by the data bags that
# data_bag_parser.rb merges in, or by higher precedence attributes applied
# later
default["cassandra"]["cluster_nodes"] = {}
default["cassandra"]["datacenter"] = nil
default["cassandra"]["datacenter_suffix"] = "az1"
default["cassandra"]["rack"] = nil
default["cassandra"]["default_datacenter"] = "DC1"
default["cassandra"]["default_rack"] = "RAC1"
default["cassandra"]["rackdc"]["prefer_local"] = false
default["cassandra"]["seed_list"] = [node['ipaddress']]

case node["platform_family"]
when "rhel"
  ds_url = "http://rpm.datastax.com/community"
  ds_key = nil
  ds_components = nil
  default["cassandra"]["packages"].delete("python-cql")
  default["cassandra"]["conf_dir"] = "/etc/cassandra/conf"
when "debian"
  ds_url = "http://debian.datastax.com/community"
  ds_key = "http://debian.datastax.com/debian/repo_key"
  ds_components = ["stable", "main"]
  default["cassandra"]["conf_dir"] = "/etc/cassandra"
else
  raise Chef::Exceptions::UnsupportedAction,
    "Cookbook does not support #{node["platform"]} platform"
end
default["cassandra"]["repos"] = {
  "datastax_community" => {
    "description" => "DataStax Community Repo for Apache Cassandra",
    "url" => ds_url,
    "key" => ds_key,
    "components" => ds_components
  }
}
