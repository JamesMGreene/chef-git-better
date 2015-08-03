require 'chef/log'
require 'chef/mixin/shell_out'
require 'chef/provider'
require 'chef/provider/git'


class Chef
  class Provider
    class GitSingleBranch < Chef::Provider::Git

      # Create a run_context for provider instances. Each provider action
      # becomes an isolated recipe with its own compile/converge cycle.
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
          args << "-o #{remote}"         if remote != 'origin'
          args << "--branch #{revision}" if revision and git_minor_version >= Gem::Version.new('1.7.10')
          args << "--single-branch"      if revision and git_minor_version >= Gem::Version.new('1.7.10')
          args << "--depth 1"            if revision and git_minor_version >= Gem::Version.new('1.7.10') and !depth
          args << "--depth #{depth}"     if depth

          Chef::Log.info "#{@new_resource} cloning branch #{revision} from repo #{repo} to #{dest_dir}"

          clone_cmd = "git clone #{args.join(' ')} \"#{repo}\" \"#{dest_dir}\""
          shell_out!(clone_cmd, run_options)
        end
      end

    end
  end
end
