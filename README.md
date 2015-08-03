# [`git_better`](https://github.com/JamesMGreene/chef-git-better) [![GitHub Latest Release](https://badge.fury.io/gh/JamesMGreene%2Fchef-git-better.png)](https://github.com/JamesMGreene/chef-git-better) [![Build Status](https://secure.travis-ci.org/JamesMGreene/chef-git-better.png?branch=master)](https://travis-ci.org/JamesMGreene/chef-git-better) [![Chef Cookbook](http://img.shields.io/cookbook/v/git_better.svg)](https://supermarket.chef.io/cookbooks/git_better)

A [Chef](https://www.chef.io/chef/) cookbook to provide a selection of better Git Provider(s) for Chef `deploy` resources.


## Supported Platforms

### Verified

 - **RHEL:** Amazon Linux


### Unverified

 - **RHEL:** RedHat, CentOS, Scientific, Oracle, Fedora, etc.
 - **Debian:** Debian, Ubuntu, LinuxMint, etc.
 - **MacOS X:** MacOS X, MacOS X Server, etc.
 - **Windows:** Windows, MinGW32, MSWin, etc.
 - **Solaris:** Solaris, Solaris2, OpenSolaris, OmniOS, SmartOS, etc.



## Requirements

Assumes that `git >= 1.7.10` is installed on the system (Chef assumes the same).



## Usage

Add the `git_better` cookbook to your Berksfile or other cookbook-fetching mechanism.

Then, in some recipe file where you are using a `deploy` resource:

```chef

deploy '/srv/www/my_app' do

  # Set `scm_provider` to `Chef::Provider::GitSingleBranch` (instead of `:git`, or default)
  scm_provider Chef::Provider::GitSingleBranch

  repository   'git@github.com:YourUsername/YourProject.git'
  revision     'my_branch'
  user         'deploy'
  group        'www-data'

  # ...
  # etc., other attributes, etc.
  # ...
end

```

Deploy a Git-based application from the repository `git@github.com:YourUsername/YourProject.git` but **ONLY** clone the `my_branch` branch.



## Gotchas

If the `shallow_clone` attribute of a `deploy` resource is not included or is set to `false`, this provider will default to setting `depth` equal to `1`. However, if `shallow_clone` is set to `true`, Chef unfortunately forcibly binds this provider to using a `depth` of `5` instead.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Run the unit tests (`bundle exec rake spec`)
5. Run test kitchen (`bundle exec kitchen test`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request



## License

Copyright (c) 2015, James M. Greene (MIT License)
