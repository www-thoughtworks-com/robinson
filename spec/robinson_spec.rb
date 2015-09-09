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

  let(:host) { 'localhost:6161' }

  describe 'command line usage' do

    it 'should return 0 status code on success' do
      robinson_main [host, '--ignoring', '^/.+']
      expect(@@exit_code).to eq 0
    end

    it 'should allow throttling of requests' do
      robinson_main([host, '--delay', '0.5'])
      expect(@@exit_code).to eq 0
    end

    it 'should fail on unknown options' do
      robinson_main([host, '--freeble-goodies'])
      expect(@@exit_code).to_not eq 0
    end
  end

  describe 'link following' do

    before :all do
      @reporter = TestExpectationReporter.new
      Robinson.crawl('localhost:6161', [], 0, @reporter)
    end

    it 'should delay the spidering' do
      delay = 0.05
      reporter = TestExpectationReporter.new

      start = Time.now
      Robinson.crawl(host, [], delay, reporter)
      duration = Time.now - start

      expect(duration).to be >= ((visited_urls(reporter).count - 1) * delay)
    end

    it 'should follow non-anchored links' do
      expect(visited_urls(@reporter)).to include *%W(http://#{host}/ http://#{host}/some-page http://#{host}/some-page?a=b)
    end

    it 'should follow path of path and anchor link' do
      expect(visited_urls(@reporter)).to include "http://#{host}/some/path/with/anchor"
    end

    it 'should not follow simple in-page anchor' do
      expect(visited_urls(@reporter)).not_to include "http://#{host}/#some-anchor"
    end

    it 'should follow path of link with crappy anchor that has lots of non-html-spec chars in it' do
      expect(visited_urls(@reporter)).to include "http://#{host}/path/with/crappy/anchor.in.it"
    end
  end

  describe 'images link following' do

    before :all do
      @reporter = TestExpectationReporter.new
      Robinson.crawl_images('localhost:6161', [], 0, @reporter)
    end

    it 'should follow path of img src' do
      puts visited_urls(@reporter)
      expect(visited_urls(@reporter)).to include "http://#{host}/relative-test-image-link"
    end
  end

end

def visited_urls(reporter)
  reporter.visited_pages.map { |page| page.url.to_s }
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
        <img src="/relative-test-image-link"/>
      </body>
    </html>

    html

  end
end