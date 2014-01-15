#
# Cookbook Name:: casserole
# Recipe:: packages
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

node["cassandra"]["build_packages"].each do |pkg|
  p = package "#{pkg}" do
    action :nothing
  end
  p.run_action(:install)
end

node["cassandra"]["packages"].each do |pkg, attrs|
  package pkg do
    action :install
    version attrs["version"] if attrs["version"]
  end
end

node["cassandra"]["chef_gems"].each do |pkg, attrs|
  chef_gem pkg do
    action :install
    version attrs["version"] if attrs["version"]
  end
end

# Install the metrics-graphite jar
if node['cassandra']['metrics']['graphite']['enabled'] == true
  cookbook_file "metrics-graphite-2.2.0.jar" do
    path File.join(node['cassandra']['home_dir'], '/lib','metrics-graphite-2.2.0.jar')
    action :create_if_missing
  end
end
