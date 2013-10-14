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

  describe 'link following' do
    let(:reporter) { TestExpectationReporter.new }
    let(:host) {'localhost:6161'}

    before :all do
      Robinson.crawl(host, [], reporter)
    end

    it 'should follow non-anchored links' do
      visited_urls(reporter).should include *%W(http://#{host}/ http://#{host}/some-page http://#{host}/some-page?a=b)
    end

    it 'should follow path of path and anchor link' do
      visited_urls(reporter).should include "http://#{host}/some/path/with/anchor"
    end

    it 'should not follow simple in-page anchor' do
      visited_urls(reporter).should_not include "http://#{host}/#some-anchor"
    end

    it 'should follow path of link with crappy anchor that has lots of non-html-spec chars in it' do
      visited_urls(reporter).should include "http://#{host}/path/with/crappy/anchor.in.it"
    end
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
        <a href="/some/path/with/anchor#anchor-should-be-removed">Path and anchor</a>
        <a href="/path/with/crappy/anchor.in.it#anchor-with-lots-of.crap@$%^&*(.in-it">Crappy anchor</a>
      </body>
    </html>

    html

  end
end