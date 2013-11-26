#
# Cookbook Name:: casserole
# Recipe:: user
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

include_recipe "ulimit"

u = node["cassandra"]["user"]
g = node["cassandra"]["group"]

user u do
  comment "Apache Cassandra user"
  home node["cassandra"]["home_dir"]
  shell "/bin/bash"
  system true
  action :create
end

group g do
  members [u]
  system true
  action :create
  only_if { u != g }
end

user_ulimit u do
  filehandle_limit node['cassandra']['limits']['nofile']
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
