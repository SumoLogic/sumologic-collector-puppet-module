require 'spec_helper'

RSpec.describe 'sumo::win_config' do
  let(:facts) { { architecture: 'x86_64', kernel: 'windows' } }

  context 'with manage_sources false' do
    let(:params) { { manage_sources: false, accessid: 'accessid', accesskey: 'accesskey' } }
    it { is_expected.not_to contain_file('C:\sumo\sumo.json') }
  end

  context 'with manage_config_file false' do
    let(:params) { { manage_config_file: false, accessid: 'accessid', accesskey: 'accesskey' } }
    it { is_expected.not_to contain_file('C:\sumo\sumo.conf') }
  end

  let(:params) do
    {
      manage_sources: true,
      manage_config_file: true,
      accessid: 'accessid',
      accesskey: 'accesskey',
    }
  end

  it { is_expected.to compile }

  it { is_expected.to contain_file('C:\sumo\download_sumo.ps1') }
  it { is_expected.to contain_file('C:\sumo') }
  it { is_expected.to contain_file('C:\sumo\sumo.json') }
  it { is_expected.to contain_file('C:\sumo\sumo.conf') }

  it { is_expected.to contain_exec('download_sumo') }
  it { is_expected.to contain_package('sumologic') }
end
