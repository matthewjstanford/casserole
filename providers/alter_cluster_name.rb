def load_current_resource
  super
end

action :run do
  script "alter_cluster_name #{new_resource.name}" do
    interpreter "bash"
    user "root"

    conf = YAML.load_file('/etc/cassandra/conf/cassandra.yaml')

    listen_address = conf['rpc_address'] || node['ipaddress']
    listen_port = conf['rpc_port'] || "9160"

    listen_address = '127.0.0.1' if listen_address == 'localhost'

    #cluster_name = new_resource.name.chars.map {|c| c.unpack('H*')}.join

    code "echo \"update local set cluster_name = '#{new_resource.name}' where key = 'local';\" | cqlsh -k system #{listen_address} #{listen_port}"

    not_if <<-BASH
    vCN=`echo "select cluster_name from local where key = 'local';" | cqlsh --no-color -k system #{listen_address} #{listen_port} | grep -A 2 cluster_name | tail -n 1 | sed -e 's/^ *//g' -e 's/ *$//g'`
    if [ "$vCN" == "#{new_resource.name}" ]; then
        echo "match"
        exit 0
      else
        echo "no match"
        exit 1
    fi
    BASH

    notifies :run, "script[flush #{new_resource.name}]", :immediate
  end

  script "flush #{new_resource.name}" do
    interpreter "bash"
    user "root"
    code "nodetool flush"
    action :nothing
  end
end

action :nothing do
end
