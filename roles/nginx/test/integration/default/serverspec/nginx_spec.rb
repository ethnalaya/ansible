require 'serverspec'
require 'pathname'

set :backend, :exec

describe 'nginx' do
  describe package('nginx') do
    it { should be_installed }
  end
  describe service('nginx') do
    it { should be_running }
    it { should be_enabled }
  end
  describe file('/etc/nginx/nginx.conf') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    it { should be_mode('644') }
  end
  describe port(80) do
    it { should be_listening }
    it { should be_listening.on('0.0.0.0').with('tcp') }
  end
end