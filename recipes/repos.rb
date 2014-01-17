#
# Cookbook Name:: casserole
# Recipe:: repos
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

case node["platform_family"]
when "rhel"
  major_ver = node["platform_version"].split(".")[0].to_i

  include_recipe "yum"
  include_recipe "yum::epel" if major_ver == 5

  node["cassandra"]["repos"].each do |name, attrs|

    yum_repository name do
      description attrs["description"]
      baseurl attrs["url"]
      gpgkey attrs["key"] if attrs["key"]
      gpgcheck false unless attrs["key"]
      action :create
      action :add
    end
  end
when "debian"
  include_recipe "apt"

  node["cassandra"]["repos"].each do |name, attrs|
    apt_repository name do
      uri attrs["url"]
      components attrs["components"]
      key attrs["key"] if attrs["key"]
    end
  end
else
  raise Chef::Exceptions::UnsupportedAction,
    "Cookbok does not support #{node["platform"]} platform"
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
