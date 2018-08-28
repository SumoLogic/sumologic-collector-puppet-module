require 'spec_helper_acceptance'
require 'beaker-puppet'

describe 'sumo class: management of sources' do
  # Using puppet_apply as a helper
  it 'should work idempotently with no errors' do
    pp = <<-EOS
    class { 'sumo':
      accessid           => 'Type access ID here',
      accesskey          => 'Type access key here',
      manage_sources     => true,
    }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe file('/usr/local/sumo') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/sumo/sumoVarFile.txt') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { should contain 'accessid' }
    it { should contain 'accesskey' }
  end

  describe file('/usr/local/sumo/sources.json') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe service('collector') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
