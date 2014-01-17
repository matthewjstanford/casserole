include_recipe "#{cookbook_name}::repos"

node["cassandra"]["opscenter"]["packages"].each do |pkg, attrs|
  package pkg do
    action :install
    version attrs["version"] if attrs["version"]
  end
end

service "opscenterd"

template "/etc/opscenter/opscenterd.conf" do
  source "opscenter/opscenterd.conf.erb"
  variables(
    :ipaddress  => node["cassandra"]["opscenter"]["ipaddress"],
    :port       => node["cassandra"]["opscenter"]["port"],
    :log_level  => nil,
    :passwd_file => nil
  )
  action :create
  notifies :restart, "service[opscenterd]", :immediate
end

service "opscenterd" do
  action [:start, :enable]
end
