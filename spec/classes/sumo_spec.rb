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

  context 'with both json source path and content' do
    let(:params) {
      {
        manage_sources: true,
        sumo_json_content: 'test',
        sumo_json_source_path: 'test',
      }
    }
    it { is_expected.to compile.and_raise_error(/You must define exactly one of/) }
  end

  context 'with json content' do
    let(:params) {
      {
        accessid: 'accessid',
        accesskey: 'accesskey',
        manage_sources: true,
        sumo_json_content: 'test',
      }
    }
    it { is_expected.to contain_file('/usr/local/sumo/sumo.json').with_content('test') }
  end

  context 'with no sources management' do
    let(:params) {
      {
        accessid: 'accessid',
        accesskey: 'accesskey',
        manage_sources: false,
        sumo_json_content: 'test',
      }
    }
    it { is_expected.to compile }
  end

  context 'with json content on windows' do
    let(:facts) { { osfamily: 'windows', architecture: 'x86_64' } }
    let(:params) {
      {
        accessid: 'accessid',
        accesskey: 'accesskey',
        manage_sources: true,
        sumo_json_content: 'test',
      }
    }
    it { is_expected.to contain_file('C:\sumo\sumo.json').with_content('test') }
  end
end
