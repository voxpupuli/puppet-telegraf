require 'spec_helper'
describe 'telegraf' do

  context 'with defaults for all parameters' do
    it { should contain_class('telegraf') }
  end
end
