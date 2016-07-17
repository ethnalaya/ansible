require 'serverspec'
require 'pathname'

set :backend, :exec

describe 'jenkins' do
    describe package('jenkins') do
      it { should be_installed }
    end
    describe service('jenkins') do
      it { should be_running }
      it { should be_enabled }
    end
end