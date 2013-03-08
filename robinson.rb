#!/bin/ruby

require 'patron'
require 'nokogiri'

base = ARGV.first.to_s
puts "base: '#{base}'"

class Fetcher
  def initialize(base)
    @http = Patron::Session.new
    @http.base_url = base
  end
  def fetch(path)
    @http.get(path).body
  end
end


class Page
  def initialize(fetcher, path)
    @fetcher = fetcher
    @path = path
  end
  def internal_links
    page = Nokogiri::HTML(@fetcher.fetch(@path))
    links(page).select { |href| href.start_with?('/') || !href.start_with?('http') }
  end
  private
  def links(page)
    page.css('a').collect{ |a| a.attr('href') }
  end
end

def crawl page
  puts page.internal_links
end

crawl Page.new(Fetcher.new(base), '/')
