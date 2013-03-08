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
  def internal_pages
    pages = []
    internal_links.collect {|link| Page.new(@fetcher, link) }
  end
  def to_s
    "Page: '#{@path}'"
  end
  private
  def links(page)
    page.css('a').collect{ |a| a.attr('href') }
  end
end

def pages_under page
  page.internal_pages
end

puts pages_under(Page.new(Fetcher.new(base), '/'))
