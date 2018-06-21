# frozen_string_literal: true

require 'spec_helper'
require 'rspec-puppet-facts'
require 'rspec-puppet-facts-unsupported'

include RspecPuppetFacts
include RspecPuppetFactsUnsupported

at_exit { RSpec::Puppet::Coverage.report! }

shared_context :unsupported do
  on_unsupported_os.each do |os, facts|
    context "on unsupported OS '#{os}'" do
      let(:facts) { facts }
      it { is_expected.to compile.and_raise_error(/Unsupported operating system/) }
    end
  end
end
