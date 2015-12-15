require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

hosts.each do |_host|
  # Install Puppet
  run_puppet_install_helper
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'collectd')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), :acceptable_exit_codes => [0]
      on host, puppet('module', 'install', 'puppetlabs-concat'), :acceptable_exit_codes => [0]
    end
  end
end
