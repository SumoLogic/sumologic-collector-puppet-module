require 'spec_helper'
describe 'sumo' do
  let(:facts) { { osfamily: 'Debian', architecture: 'x86_64', sources_file_exists: true, sync_file_exists: true, service_file_exists: false } }

  context 'with defaults for all parameters' do
    it { is_expected.to compile.and_raise_error(/Please provide an/) }
  end

  context 'with sources_override false ' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: false } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/etc/sumo/sumoVarFile.txt') }
    it { is_expected.to contain_exec('Download Sumo Executable') }
    it { is_expected.to contain_exec('Execute sumo') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sources_override false and use package true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: false, use_package: true } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_exec('Download SumoCollector Package') }
    it { is_expected.to contain_file('user.properties') }
    it { is_expected.to contain_package('collector') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sources_override true ' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: true } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/usr/local/sumo/sources.json') }
    it { is_expected.to contain_file('/etc/sumo/sumoVarFile.txt') }
    it { is_expected.to contain_exec('Download Sumo Executable') }
    it { is_expected.to contain_exec('Execute sumo') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sources_override true and use package true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: true, use_package: true } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/usr/local/sumo/sources.json') }
    it { is_expected.to contain_exec('Download SumoCollector Package') }
    it { is_expected.to contain_file('user.properties') }
    it { is_expected.to contain_package('collector') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sync_sources_override false and local_config_mgmt true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: false } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/etc/sumo/sumoVarFile.txt') }
    it { is_expected.to contain_exec('Download Sumo Executable') }
    it { is_expected.to contain_exec('Execute sumo') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sync_sources_override false and local_config_mgmt true and use package true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: false, use_package: true } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_exec('Download SumoCollector Package') }
    it { is_expected.to contain_file('user.properties') }
    it { is_expected.to contain_package('collector') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sync_sources_override true and local_config_mgmt true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: true } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/usr/local/sumo/syncsources.json') }
    it { is_expected.to contain_file('/etc/sumo/sumoVarFile.txt') }
    it { is_expected.to contain_exec('Download Sumo Executable') }
    it { is_expected.to contain_exec('Execute sumo') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sync_sources_override true and local_config_mgmt true and use package true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', use_package: true, local_config_mgmt: true, sync_sources_override: true } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/usr/local/sumo/syncsources.json') }
    it { is_expected.to contain_exec('Download SumoCollector Package') }
    it { is_expected.to contain_file('user.properties') }
    it { is_expected.to contain_package('collector') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sources_override false and local_config_mgmt false and source file does not exist' do
    let(:facts) { { osfamily: 'Debian', architecture: 'x86_64', sources_file_exists: false, sync_file_exists: false, service_file_exists: false } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: false, sources_override: false } }

    it { is_expected.to compile.and_raise_error(/Please make sure /) }
  end

  context 'with sync sources_override false and local_config_mgmt true and sync sources file does not exist' do
    let(:facts) { { osfamily: 'Debian', architecture: 'x86_64', sources_file_exists: false, sync_file_exists: false, service_file_exists: false } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: false } }

    it { is_expected.to compile.and_raise_error(/Please make sure /) }
  end

  context 'with service already exists true' do
    let(:facts) { { osfamily: 'Debian', architecture: 'x86_64', sources_file_exists: true, sync_file_exists: false, service_file_exists: true } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: false, sources_override: false } }

    it { is_expected.to contain_service('collector') }
  end

  context 'with sync sources_override true and local_config_mgmt true and service already exists' do
    let(:facts) { { osfamily: 'Debian', architecture: 'x86_64', sources_file_exists: false, sync_file_exists: false, service_file_exists: true } }
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', local_config_mgmt: true, sync_sources_override: true } }

    it { is_expected.to contain_file('/usr/local/sumo/syncsources.json') }
    it { is_expected.to contain_service('collector') }
  end

  context 'with sources_override false and skip registration true' do
    let(:params) { { accessid: 'accessid', accesskey: 'accesskey', sources_override: false, skip_registration: 'true' } }

    it { is_expected.to contain_class('sumo::nix_config') }
    it { is_expected.to contain_class('sumo::nix_install') }
    it { is_expected.to contain_file('/usr/local/sumo') }
    it { is_expected.to contain_file('/etc/sumo/sumoVarFile.txt') }
    it { is_expected.to contain_exec('Download Sumo Executable') }
    it { is_expected.to contain_exec('Execute sumo') }
    it { is_expected.not_to contain_service('collector') }
  end
end
