#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: webpi
# Provider:: product
#
# Copyright:: 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/mixin/shell_out'

include Chef::Mixin::ShellOut
include Windows::Helper

action :install do
  cmd = "#{webpicmd} /Install"
  cmd << " /products:#{@new_resource.product_id} /suppressreboot"
  cmd << " /accepteula" if @new_resource.accept_eula
  cmd << " /XML:#{node['webpi']['xmlpath']}" if node['webpi']['xmlpath']
  shell_out!(cmd, {:returns => [0,42]})
  @new_resource.updated_by_last_action(true)
  Chef::Log.info("#{@new_resource} added new product '#{@new_resource.product_id}'")
end

def webpicmd
  @webpicmd ||= begin
    node['webpi']['bin']
  end
end
