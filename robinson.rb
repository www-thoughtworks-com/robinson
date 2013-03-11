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
    #puts "seen: #{uri}"
  end
  def on_visit(uri, http_status_code)
    puts "checked: #{uri} - #{http_status_code}"
  end
end

Anemone.crawl("http://#{address}") do |anemone|
  reporter = Reporter.new
  anemone.focus_crawl { |page|
    page.links.each { |link| reporter.on_see_link(link) }
    links = page.links.select { |uri|
      link = Link.new(uri)
      link.on_website?(address)
    }
    links
  }
  anemone.on_every_page { |page|
    reporter.on_visit page.url, page.code
  }
end
