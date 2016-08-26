require 'spec_helper_acceptance'

describe 'sumo class: management of sources/config' do
  # Using puppet_apply as a helper
  it 'should work idempotently with no errors' do
    pp = <<-EOS
    class { 'sumo':
      accessid           => 'XXXX: must be filled in to work',
      accesskey          => 'YYYY: must be filled in to work',
      manage_config_file => true,
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

  describe file('/etc/sumo.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { should contain 'accessid' }
    it { should contain 'accesskey' }
  end

  describe file('/usr/local/sumo/sumo.json') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { should contain 'linux_auth_logs' }
  end
end
