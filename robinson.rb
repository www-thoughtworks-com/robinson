#!/bin/ruby

require 'patron'
require 'nokogiri'
require 'set'

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
  include Comparable
  attr_reader :path
  def initialize(fetcher, path)
    @fetcher = fetcher
    @path = path
  end
  def internal_links
    page = Nokogiri::HTML(@fetcher.fetch(@path))
    links(page).select { |href| href.start_with?('/') || !href.start_with?('http') }
  end
  
  def internal_pages
    puts "getting internal pages for: #{@path}"
    not_me = internal_links.select{ |link| link != @path}
    pages = not_me.collect {|link| Page.new(@fetcher, link) }.uniq
    puts "new pages found: #{pages.size}"
    pages
  end
  def <=>(other)
    @path <=> other.path
  end
  def eql?(other)
    @path == other.path
  end
  def hash
    @path.hash
  end
  def to_s
    "Page: '#{@path}'"
  end
  private
  def links(page)
    page.css('a').collect{ |a| a.attr('href') }
  end
end

def pages_under(page, except_for = [page])
  next_pages = [] 
  puts "pages_under: #{page} except for #{except_for}"
  
  next_pages = (next_pages + page.internal_pages.select { |internal_page| 
    puts "checking equality for #{internal_page}"
    except_this_page = except_for.include?(internal_page)

    !except_this_page
  }).uniq


  all_pages = (next_pages + except_for).uniq
  puts "next pages: #{next_pages}"
  next_pages.each { |next_page| all_pages = (all_pages + pages_under(next_page, all_pages)).uniq }
end



puts pages_under(Page.new(Fetcher.new(base), '/'))
