maintainer	 "Chris Mutchler"
maintainer_email "chris@virtualelephant.com"
license		 "Apache 2.0"
description	 "Installs/Configures mesosphere stack"
version		 "0.1.0"

description	 "Installs/Configures mesosphere stack using Mesosphere official CentOS repository"

depends		 "java"
depends		 "install_from"
depends		 "cluster_service_discovery"
depends		 "hadoop_common"
depends		 "hadoop_cluster"

recipe		 "mesos::default", "Install/Configure mesos"

%w{ redhat centos}.each do |os|
  supports os
end

