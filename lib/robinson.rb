#!/bin/ruby
require 'anemone'
require_relative 'link'
require_relative 'page'
require_relative 'investigative_reporter'

class Robinson
  def self.crawl(address, ignored_paths = [], reporter = InvestigativeReporter.new)

    puts "Website server to check: '#{address}', ignoring paths '#{ignored_paths.join(', ')}' - NB. only internal links will be checked"
    Anemone.crawl("http://#{address}") do |anemone|
      crawl_all_pages_for_links(address, anemone, ignored_paths, reporter)
      visit_page_links(anemone, reporter)
    end

    exit_code = reporter.exit_code
    puts "finished (#{exit_code})"
    exit(exit_code)

  end

  def self.crawl_all_pages_for_links(address, anemone, ignored_paths, reporter)
    anemone.focus_crawl { |page|
      report_links_on_page(page, reporter)
      get_relevant_links_on_page(address, ignored_paths, page)
    }
  end

  def self.visit_page_links(anemone, reporter)
    anemone.on_every_page { |anemone_page|
      reporter.on_visit Page.new(anemone_page)
    }
  end

  def self.report_links_on_page(page, reporter)
    page.links.each { |link| reporter.on_see_link(link) }
  end

  def self.get_relevant_links_on_page(address, ignored_paths, page)
    page.links.select { |uri|
      is_relevant_link?(address, ignored_paths, uri)
    }
  end

  def self.is_relevant_link?(address, ignored_paths, uri)
    Link.new(uri).on_website?(address) && !ignored_paths.any? { |path| !!(path =~ uri.path) }
  end
end