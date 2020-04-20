require 'spec_helper'

describe 'sumo' do
  let(:facts) { { osfamily: 'Windows', architecture: 'x86_64', sources_file_exists_win: true, sync_file_exists_win: true, service_file_exists_win: false } }

  context 'with defaults for all parameters' do
    it { is_expected.to compile.and_raise_error(/Please provide an/) }
  end

  context 'with sources_override false ' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: false } }

    it { is_expected.to contain_class('sumo::win_config') }
    it { is_expected.to contain_class('sumo::win_install') }
    it { is_expected.to contain_file('C:\sumo') }
    it { is_expected.to contain_file('C:\sumo\download_sumo.ps1') }
    it { is_expected.to contain_file('C:\sumo\sumoVarFile.txt') }
    it { is_expected.to contain_exec('download_sumo') }
    it { is_expected.to contain_package('sumo-collector') }
    it { is_expected.to contain_service('sumo-collector') }
  end

  context 'with sources_override true ' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: true } }

    it { is_expected.to contain_class('sumo::win_config') }
    it { is_expected.to contain_class('sumo::win_install') }
    it { is_expected.to contain_file('C:\sumo') }
    it { is_expected.to contain_file('C:\sumo\download_sumo.ps1') }
    it { is_expected.to contain_file('C:\\\\sumo\\\\sources.json') }
    it { is_expected.to contain_file('C:\sumo\sumoVarFile.txt') }
    it { is_expected.to contain_exec('download_sumo') }
    it { is_expected.to contain_package('sumo-collector') }
  end

  context 'with sync_sources_override false and local_config_mgmt true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: false } }

    it { is_expected.to contain_class('sumo::win_config') }
    it { is_expected.to contain_class('sumo::win_install') }
    it { is_expected.to contain_file('C:\sumo') }
    it { is_expected.to contain_file('C:\sumo\download_sumo.ps1') }
    it { is_expected.to contain_file('C:\sumo\sumoVarFile.txt') }
    it { is_expected.to contain_exec('download_sumo') }
    it { is_expected.to contain_package('sumo-collector') }
    it { is_expected.to contain_service('sumo-collector') }
  end

  context 'with sync_sources_override true and local_config_mgmt true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: true } }

    it { is_expected.to contain_class('sumo::win_config') }
    it { is_expected.to contain_class('sumo::win_install') }
    it { is_expected.to contain_file('C:\sumo') }
    it { is_expected.to contain_file('C:\sumo\download_sumo.ps1') }
    it { is_expected.to contain_file('C:\\\\sumo\\\\syncsources.json') }
    it { is_expected.to contain_file('C:\sumo\sumoVarFile.txt') }
    it { is_expected.to contain_exec('download_sumo') }
    it { is_expected.to contain_package('sumo-collector') }
    it { is_expected.to contain_service('sumo-collector') }
  end

  context 'with sources_override false and local_config_mgmt false and source file does not exist' do
    let(:facts) { { osfamily: 'Windows', architecture: 'x86_64', sources_file_exists_win: false, sync_file_exists_win: false, service_file_exists_win: false } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: false, sources_override: false } }

    it { is_expected.to compile.and_raise_error(/Please make sure /) }
  end

  context 'with sync sources_override false and local_config_mgmt true and sync sources file does not exist' do
    let(:facts) { { osfamily: 'Windows', architecture: 'x86_64', sources_file_exists_win: false, sync_file_exists_win: false, service_file_exists_win: false } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: false } }

    it { is_expected.to compile.and_raise_error(/Please make sure /) }
  end

  context 'with service already exists true' do
    let(:facts) { { osfamily: 'Windows', architecture: 'x86_64', sources_file_exists_win: true, sync_file_exists_win: false, service_file_exists_win: true } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: false, sources_override: false } }

    it { is_expected.to contain_service('sumo-collector') }
  end

  context 'with sync sources_override true and local_config_mgmt true and service already exists' do
    let(:facts) { { osfamily: 'Windows', architecture: 'x86_64', sources_file_exists_win: false, sync_file_exists_win: false, service_file_exists_win: true } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: true } }

    it { is_expected.to contain_file('C:\\\\sumo\\\\syncsources.json') }
    it { is_expected.to contain_service('sumo-collector') }
  end

  context 'with sources_override false and skip registration true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: false, skip_registration: 'true' } }

    it { is_expected.to contain_class('sumo::win_config') }
    it { is_expected.to contain_class('sumo::win_install') }
    it { is_expected.to contain_file('C:\sumo') }
    it { is_expected.to contain_file('C:\sumo\download_sumo.ps1') }
    it { is_expected.to contain_file('C:\sumo\sumoVarFile.txt') }
    it { is_expected.to contain_exec('download_sumo') }
    it { is_expected.to contain_package('sumo-collector') }
    it { is_expected.not_to contain_service('sumo-collector') }
  end
end
