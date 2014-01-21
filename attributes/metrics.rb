# Graphite metrics
default['cassandra']['metrics']['graphite']['enabled'] = false
default['cassandra']['metrics']['graphite']['period'] = 120
default['cassandra']['metrics']['graphite']['timeunit'] = 'SECONDS'
default['cassandra']['metrics']['graphite']['host'] = nil # If set will not perform chef search
default['cassandra']['metrics']['graphite']['host_query'] = "role:graphite_server AND chef_environment:#{node.chef_environment}"
default['cassandra']['metrics']['graphite']['port'] = 2003
default['cassandra']['metrics']['graphite']['predicate']['white']['useQualifiedName'] = true
default['cassandra']['metrics']['graphite']['predicate']['white']['patterns'] = ["^org.apache.cassandra.metrics.Cache.+",
                                                                                "^org.apache.cassandra.metrics.ClientRequest.+",
                                                                                "^org.apache.cassandra.metrics.Storage.+",
                                                                                "^org.apache.cassandra.metrics.ThreadPools.+" ]


