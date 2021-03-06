#
# Author:: Patrick Collins (<pat@burned.com>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper.rb')

describe Ohai::System, "Darwin Memory Plugin" do
  before(:each) do
    darwin_memsize = <<-DARWIN_MEMSIZE
17179869184
    DARWIN_MEMSIZE
    darwin_vm_stat = <<-DARWIN_VM_STAT
Mach Virtual Memory Statistics: (page size of 4096 bytes)
Pages free:                        2155305.
Pages active:                       924164.
Pages inactive:                     189127.
Pages speculative:                  531321.
Pages wired down:                   391749.
"Translation faults":             14107520.
Pages copy-on-write:                810071.
Pages zero filled:                 6981505.
Pages reactivated:                    1397.
Pageins:                            630064.
Pageouts:                                0.
Object cache: 12 hits of 139872 lookups (0% hit rate)
    DARWIN_VM_STAT

    @plugin = get_plugin("darwin/memory")
    @plugin.stub(:collect_os).and_return(:darwin)
    @plugin.stub(:shell_out).with("sysctl -n hw.memsize").and_return(mock_shell_out(0, darwin_memsize, ""))
    @plugin.stub(:shell_out).with("vm_stat").and_return(mock_shell_out(0, darwin_vm_stat, ""))
    @plugin.run
  end

  it "should set memory[:total] to 16384MB" do
    @plugin[:memory][:total].should == '16384MB'
  end

  it "should set memory[:active] to 5140MB" do
    @plugin[:memory][:active].should == '5140MB'
  end

  it "should set memory[:inactive] to 738MB" do
    @plugin[:memory][:inactive].should == '738MB'
  end

  it "should set memory[:free] to 10504MB" do
    @plugin[:memory][:free].should == '10504MB'
  end
end
