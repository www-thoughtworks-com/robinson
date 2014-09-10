require 'rspec'
require_relative '../lib/options'
require 'pp'

describe 'Options' do

  let (:options) {Options.new}

  it 'should return a nil address if there are no arguments' do
    expect(options.parse([]).address).to be_nil
  end

  it 'should return the address as the first argument' do
    expect(options.parse(['www.thing.com']).address).to eq 'www.thing.com'
  end

  it 'should return an optional argument for throttling' do
    expect(options.parse(['www.thing.com','--delay','0.25']).delay).to eq 0.25
  end

  it 'should default the delay to nothing' do
    expect(options.parse(['www.thing.com']).delay).to eq 0
  end

  it 'should return the list of URL patterns to ignore' do
    expect(options.parse(['www.thing.com','--ignoring','^(?:/..)?/blogs/?.*','^(?:/..)?/clients/?.*', 'test']).ignoring).to eq ['^(?:/..)?/blogs/?.*','^(?:/..)?/clients/?.*', 'test']
  end

  it 'should return an optional argument for changing the number of threads' do
    expect(options.parse(['www.thing.com', '--threads', '2']).threads).to eq 2
  end

  it 'should default the number of threads to 2' do
    expect(options.parse(['www.thing.com']).threads).to eq 2
  end
end