# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'glassfish' do
  let(:code) { example 'glassfish' }

  it 'should work with no errors' do
    result = apply_manifest(code, catch_failures: true)
    expect(result.exit_code).to be(2)
  end

  it 'should work idempotently' do
    apply_manifest(code, catch_changes: true)
  end

  describe service('glassfish') do
    it { is_expected.to be_running }
  end
end
