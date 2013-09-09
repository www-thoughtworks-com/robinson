require 'rspec'
require 'sinatra'
require 'tw-testing'
require_relative '../lib/invocation'
require_relative 'test_expectation_reporter'
require 'uri'

describe 'Robinson' do

  before(:all) do
    FakeWebsite.start_service
  end

  after(:all) do
    FakeWebsite.stop_service
  end

  it 'should return 0 status code on success' do
    robinson_main(%w(www.thoughtworks.com --ignoring ^/.+))
    @@exit_code.should eq 0
  end

  it 'should only follow links' do
    reporter = TestExpectationReporter.new
    host = 'localhost:6161'
    Robinson.crawl(host, [], reporter)

    visited_urls(reporter).should =~ %W(http://#{host}/ http://#{host}/some-page http://#{host}/some-page?a=b)
  end

end

def visited_urls(reporter)
  reporter.visited_pages.map {|page| page.url.to_s}
end

def exit(code)
  @@exit_code = code
end

class FakeWebsite < Sinatra::Base
  @@server = nil

  def self.start_service
    @@server = FakeServer.new self, 6161
    @@server.start
  end

  def self.stop_service
    @@server.stop if @@server
  end

  get %r{^/.*} do
    <<-html

    <html>
      <head>
      </head>
      <body>
        <a href="/some-page?a=b">Some page</a>
        <a href="/some-page">Some page</a>
        <a href="#some-anchor">First anchor</a>
      </body>
    </html>

    html

  end
end