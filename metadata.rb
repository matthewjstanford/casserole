name              "cassandra"
maintainer        "Matthew Stanford"
maintainer_email  "matthewjstanford@gmail.com"
license           "Apache v2.0"
description       "Installs/Configures Apache Cassandra"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "2.1.0"

depends           "yum", "~> 3.0"
depends           "apt"
depends           "java", "~> 1.22"
depends           "sysctl", "~> 0.6"
depends           "ntp"

supports          "redhat", ">= 6.0"
supports          "centos", ">= 6.0"
supports          "amazon", ">= 2013.0"
