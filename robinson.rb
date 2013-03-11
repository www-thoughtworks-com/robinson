#!/bin/ruby


address = ARGV.first.to_s
puts "address: '#{address}'"

require 'anemone'


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
      $stdout.puts "BROKEN!!: #{@page.url} - #{@page.code}"
    else
      $stdout.puts "checked: #{@page.url} - #{@page.code}"
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
