require 'spec_helper'

RSpec.describe 'sumo' do
  let(:facts) { { osfamily: 'Debian', architecture: 'x86_64' } }

  it { is_expected.to compile }
end
