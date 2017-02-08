require 'spec_helper'

RSpec.describe 'sumo::nix_config' do
  let(:facts) { { architecture: 'x86_64' } }

  context 'with manage_sources false' do
    let(:params) { { manage_sources: false, accessid: 'accessid', accesskey: 'accesskey' } }
    it { is_expected.not_to contain_file('/usr/local/sumo/sumo.json') }
  end

  context 'with manage_config_file false' do
    let(:params) { { manage_config_file: false, accessid: 'accessid', accesskey: 'accesskey' } }
    it { is_expected.not_to contain_file('/etc/sumo.conf') }
  end

  context 'with only accessid and accesskey' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey' } }
    it { is_expected.to compile }
  end

  context 'with no accessid/accesskey' do
    let(:params) { { } }
    it { is_expected.to compile.and_raise_error(/You must provide/) }
  end

  context 'with manage_sources = true, manage_config_file = true' do
    let(:params) do
      {
        manage_sources: true,
        manage_config_file: true,
        accessid: 'accessid',
        accesskey: 'accesskey',
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/usr/local/sumo/sumo.json') }
    it { is_expected.to contain_file('/etc/sumo.conf') }
    it { is_expected.to contain_exec('Download Sumo Executable') }
    it { is_expected.to contain_exec('Execute sumo') }
  end

  context 'with use_package = true' do
    let(:params) do
      {
        accessid: 'accessid',
        accesskey: 'accesskey',
        use_package: true,
      }
    end
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_exec('Download SumoCollector Package') }
    it { is_expected.to contain_package('sumocollector') }
    it { is_expected.to contain_service('sumocollector') }
  end
end
