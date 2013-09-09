require 'rspec'
require_relative '../lib/invocation'

describe 'Robinson' do

  it 'should check links on TW.com homepage' do
    robinson_main(%w(www.thoughtworks.com --ignoring ^/.+))
    @@exit_code.should eq 0
  end

end

def exit(code)
  @@exit_code = code
end