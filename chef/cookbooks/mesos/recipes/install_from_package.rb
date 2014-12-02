#
#   Copyright (c) 2012-2014 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

include_recipe "hadoop_common::add_repo"
include_recipe "hadoop_cluster::update_attributes"

#
# Setup Mesosphere repo
#
remote_file "/root/mesosphere-el-repo-6-2.noarch.rpm" do
  source "http://repos.mesosphere.io/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm"
  action :create
end

rpm_package "mesosphere-el-repo-6-2.noarch.rpm" do
  source "/root/mesosphere-el-repo-6-2.noarch.rpm"
  action :install
end

%w( mesos ).each do |pkg|
  yum_package pkg do
    action :install
  end
end

#
# Write Zookeeper node information to /etc/mesos/zk
#

run_in_ruby_block "Discover zookeeper nodes" do
  set_action(HadoopCluster::ACTION_WAIT_FOR_SERVICE, node[:zookeeper][:zookeeper_service_name])
  zookeeper_count = all_nodes_count({"role" => "zookeeper"})
  zookeeper_nodes = all_providers_for_service(node[:zookeeper][:zookeeper_service_name], true, zookeeper_count)
  zookeeper_ips = all_provider_private_ips(node[:zookeeper][:zookeeper_service_name], true, zookeeper_count)

  conf_prefix = "zk://"
  conf_suffix = "/mesos/"
  conf_line = conf_prefix

  zookeeper_ips.each do |zk|
    #$stderr.puts zk
    conf_line = conf_line + zk + ":2181," 
  end

  conf_line = conf_line.chop
  conf_line = conf_line + conf_suffix
  
  fd = IO.sysopen "/etc/mesos/zk", "w"
  ios = IO.new(fd, "w")
  ios.puts conf_line
  ios.close
  clear_action
end
