name              "casserole"
maintainer        "Jonathan Hartman"
maintainer_email  "j@p4nt5.com"
license           "Apache v2.0"
description       "Installs/Configures Apache Cassandra"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.2.0"

depends           "yum", "= 2.0.2"
depends           "apt", "= 1.5.0"
depends           "java", "= 1.6.4"

supports          "redhat", ">= 6.0"
supports          "centos", ">= 6.0"
supports          "amazon", ">= 2013.0"

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
