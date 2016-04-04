require 'spec_helper'

RSpec.describe 'sumo::params' do
  let(:facts) { { architecture: 'x86_64' } }

  it { is_expected.to compile }

  context 'with an invalid architecture' do
    let(:facts) { { architecture: 'i386' } }
    it { is_expected.to compile.and_raise_error(/there is no supported arch/) }
  end
end
