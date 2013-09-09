#!/bin/ruby
require 'anemone'
require_relative 'link'
require_relative 'page'
require_relative 'investigative_reporter'

class Robinson
  def self.crawl(address, ignored_paths = [], reporter = InvestigativeReporter.new)

    puts "Website server to check: '#{address}', ignoring paths '#{ignored_paths.join(', ')}' - NB. only internal links will be checked"
    Anemone.crawl("http://#{address}") do |anemone|

      anemone.focus_crawl { |page|
        page.links.each { |link| reporter.on_see_link(link) }
        links = page.links.select { |uri|
          link = Link.new(uri)
          link.on_website?(address) && !ignored_paths.any? { |path| !!(path =~ uri.path)  }
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
end