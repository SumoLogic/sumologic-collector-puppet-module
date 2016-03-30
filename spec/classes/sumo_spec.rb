require 'spec_helper'

RSpec.describe 'sumo' do
  let(:facts) { { osfamily: 'Debian', architecture: 'x86_64' } }
  let(:params) do
    {
      accessid: 'accessid',
      accesskey: 'accesskey'
    }
  end

  it { is_expected.to compile }

  context 'on a window machine' do
    let(:facts) { { osfamily: 'windows', architecture: 'x86_64' } }
    it { is_expected.to contain_class('sumo::win_config') }
  end

  context 'on a *nix machine' do
    it { is_expected.to contain_class('sumo::nix_config') }
  end
end
