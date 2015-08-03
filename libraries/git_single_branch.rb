# Author:: James M. Greene (<james.m.greene@gmail.com>)
# Copyright:: Copyright (c) 2015, James M. Greene
# License:: MIT

#
# Adapted from:
#   https://github.com/chef/chef/blob/11.10.0/lib/chef/provider/git.rb
#
# Author:: Daniel DeLeo (<dan@kallistec.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
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


class Chef
  class Provider
    class GitSingleBranch < Chef::Provider::Git

      include Chef::Mixin::ShellOut

      # Create a run_context for provider instances. Each provider action
      # becomes an isolated recipe with its own compile/converge cycle.
      # NOTE: This can only be included if the class is inheriting from the
      # `Chef::Provider::LWRPBase` class!
      #use_inline_resources

      # Because we're using convergent Chef resources to manage machine state,
      # we can say why_run is supported for the composite.
      def whyrun_supported?
        true
      end

      # Register with the resource resolution system.
      if Chef::Provider.respond_to?(:provides)
        provides :git_single_branch
      end


      # Override the method to `clone` a single branch only instead of the
      # entire repository (all branches).
      def clone
        converge_by("clone branch #{@new_resource.revision} from #{@new_resource.repository} into #{@new_resource.destination}") do
          dest_dir = @new_resource.destination
          repo     = @new_resource.repository
          remote   = @new_resource.remote
          revision = @new_resource.revision
          depth    = @new_resource.depth

          args = []
          args << "clone"
          args << "-o #{remote}"         if remote != 'origin'
          args << "--branch #{revision}" if revision and git_minor_version >= Gem::Version.new('1.7.10')
          args << "--single-branch"      if revision and git_minor_version >= Gem::Version.new('1.7.10')
          args << "--depth 1"            if revision and git_minor_version >= Gem::Version.new('1.7.10') and !depth
          args << "--depth #{depth}"     if depth
          args << "\"#{repo}\""
          args << "\"#{dest_dir}\""

          Chef::Log.info "#{@new_resource} cloning branch #{revision} from repo #{repo} to #{dest_dir}"

          clone_cmd = git(*args)
          shell_out!(clone_cmd, run_options)
        end
      end


      #
      # Taken from:
      #   https://github.com/chef/chef/blob/12.0.0/lib/chef/provider/git.rb#L107-L109
      #
      def git_minor_version
        @git_minor_version ||= Gem::Version.new(shell_out!('git --version', run_options).stdout.split.last)
      end

    end
  end
end
