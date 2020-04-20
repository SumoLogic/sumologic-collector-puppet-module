require 'spec_helper_acceptance'

describe 'sumo class: management of sources', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  it 'is_expected.to work idempotently with no errors' do
    pp = <<-EOS
    class { 'sumo':
      accessid           => 'Type your Sumo Logic Access ID here',
      accesskey          => 'Type your Sumo Logic Access Key here',
      manage_sources     => true,
    }
    EOS
    idempotent_apply(pp)
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
    it { is_expected.to contain 'accessid' }
    it { is_expected.to contain 'accesskey' }
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
