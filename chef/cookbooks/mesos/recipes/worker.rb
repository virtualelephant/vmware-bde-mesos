#
# Cookbook Name:: mesos
# Recipe::	  worker
#

# Licensed under the Apache License, Version 2.0 (the "License");
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

template '/etc/default/mesos' do
  source 'mesos.erb'
  variables config: node[:mesos][:common]
  action :create
end

remote_file "Copy mesos-init-wrapper file" do
  path "/usr/bin/mesos-init-wrapper"
  source "file:///var/chef/cache/cookbooks/mesos/templates/default/mesos-init-wrapper"
end

#
# Start mesos-slave service
#

execute "Starting mesos-slave" do
  command "nohup /usr/bin/mesos-init-wrapper slave &"
end

#
# Install worker-specific packages
#

%w( chronos ).each do |pkg|
  yum_package pkg do
    action :install
  end
end

execute "Starting Chronos" do
  command "nohup /usr/local/bin/chronos &"
end
