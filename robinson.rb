#!/bin/ruby

def usage weirdness = ''
  if weirdness.length > 0
    puts "Sorry, #{weirdness}\n"
  end
  puts "Usage: ./robinson <host>[:<port>]"
  puts "  e.g. ./robinson www.example.com"
  puts "  e.g. ./robinson localhost:8080"
  exit 1
end


address = ARGV.first.to_s
if address.include? '/' then usage('only accepts website server host[:port], not paths') end
if address.empty? then usage('you need to pass in the website server host[:port]') end

puts "Website server to check: '#{address}' - NB. only internal links will be checked"

require 'anemone'
require 'smart_colored'

class Link
  def initialize(uri)
    @uri = uri
  end
  def on_website?(address)
    #puts "#{host_and_port} vs #{host_and_port_of(address)}"
    host_and_port == host_and_port_of(address)
  end
  private
  def host_and_port_of(address)
    address.include?(':') ? address : address + ':80'
  end
  def host_and_port
    @uri.host + ':' + @uri.port.to_s
  end
end

class Reporter
  def on_see_link(uri)
  end
  def on_visit(page)
    page.puts
  end
  def exit_code
    0
  end
end

class NoisyReporter < Reporter
  def on_see_link(uri)
    puts "seen: #{uri}"
  end
end

class InvestigativeReporter < Reporter
  def initialize
    @broken = []
    @ok = []
  end
  def on_visit(page)
    if page.broken?
      @broken << page
    else
      @ok << page
    end
    page.puts
  end
  def exit_code
    @broken.empty? ? success : failure
  end
  def success
    puts "\nAll links (#{@ok.size}) check out OK."
    0
  end
  def failure
    puts "\nBroken links (#{@broken.size} out of #{@ok.size}):"
    @broken.each { |page| page.puts }
    @broken.size
  end
end

class Page
  def initialize(anemone_page)
    @page = anemone_page
  end
  def puts
    if broken?
      $stdout.puts "BROKEN!!: #{@page.url} - #{@page.code}".colored.red
    else
      $stdout.puts "checked: #{@page.url} - #{@page.code}".colored.green
    end
  end
  def broken?
    @page.code >= 400
  end
end

def crawl(address, reporter = InvestigativeReporter.new)
  Anemone.crawl("http://#{address}") do |anemone|
    anemone.focus_crawl { |page|
      page.links.each { |link| reporter.on_see_link(link) }
      links = page.links.select { |uri|
        link = Link.new(uri)
        link.on_website?(address)
      }
      links
    }
    anemone.on_every_page { |anemone_page|
      reporter.on_visit Page.new(anemone_page)
    }
  end
  exit_code = reporter.exit_code
  puts "finished (#{exit_code})" 
  exit(exit_code)
end

crawl address
