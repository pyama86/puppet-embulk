require 'beaker-rspec'

# Install Puppet agent on all hosts
install_puppet_agent_on(hosts, {})

RSpec.configure do |c|
  c.formatter = :documentation
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.before :suite do
    # Install module to all hosts
    install_dev_puppet_module(source: module_root)

    # Install dependencies
    hosts.each do |host|
      apply_manifest_on(host, 'package { "tar": }')
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))
      on(host, puppet('module', 'install', 'puppetlabs-java'))
      on(host, puppet('module', 'install', 'puppet-wget'))
    end
  end
end
