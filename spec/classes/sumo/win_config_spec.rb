require 'spec_helper'

RSpec.describe 'sumo::win_config' do
  let(:facts) { { architecture: 'x86_64', kernel: 'windows' } }

  it { is_expected.to compile }
end
