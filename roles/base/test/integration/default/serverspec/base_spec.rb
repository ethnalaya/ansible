require 'serverspec'
require 'pathname'

set :backend, :exec

describe 'base::ntp-client' do
  describe file('/etc/localtime') do
    it { should be_symlink }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
    it { should be_mode('777') }
  end

  describe package('ntp') do
    it { should be_installed }
  end
  if os[:family]=='redhat'
    describe service('ntpd') do
      it { should be_running }
      it { should be_enabled }
    end    
  end
end