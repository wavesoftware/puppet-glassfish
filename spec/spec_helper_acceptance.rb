# frozen_string_literal: true

require 'puppet'
require 'beaker-rspec'
require 'beaker/puppeter'
require 'beaker/module_install_helper'
require 'puppet-examples-helpers'

UNSUPPORTED_PLATFORMS = %w[Suse windows AIX Solaris].freeze

run_puppeter
shell 'ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet'
install_module
install_module_dependencies

shell 'puppet config set basemodulepath' \
  " '$codedir/modules:/opt/puppetlabs/puppet/modules:/etc/puppet/modules'"
shell 'puppet module list'

RSpec.configure do |c|
  c.include PuppetExamplesHelpers

  c.formatter = :documentation
end
