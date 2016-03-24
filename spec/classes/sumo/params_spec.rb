require 'spec_helper'

RSpec.describe 'sumo::params' do
  let(:facts) { { architecture: 'x86_64' } }

  it { is_expected.to compile }
end
