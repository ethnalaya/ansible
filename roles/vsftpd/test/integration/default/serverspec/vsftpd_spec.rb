require 'serverspec'
require 'pathname'

set :backend, :exec

describe 'vsftpd' do
  if os[:family]=='redhat'
    describe package('vsftpd') do
      it { should be_installed }
    end
    describe service('vsftpd') do
      it { should be_running }
      it { should be_enabled }
    end
  
    describe file('/etc/vsftpd/vsftpd.conf') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      it { should be_mode('600') }
    end
  end
  describe port(21) do
      it { should be_listening }
      it { should be_listening.on('0.0.0.0').with('tcp') }  
  end  
end