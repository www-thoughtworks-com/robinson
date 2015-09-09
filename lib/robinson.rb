#!/bin/ruby
require 'anemone'
require_relative 'link'
require_relative 'page'
require_relative 'investigative_reporter'

module Anemone
  class Page
    def to_absolute(link)
      return nil if link.nil?

      # remove anchor
      link = URI.encode(URI.decode(link.to_s.gsub(/#.*/, '')))

      relative = URI(link)
      absolute = base ? base.merge(relative) : @url.merge(relative)

      absolute.path = '/' if absolute.path.empty?

      absolute
    end
  end
end

class Robinson
  def self.crawl(address, ignored_paths = [], delay = 0, reporter = InvestigativeReporter.new)

    puts "Website server to check: '#{address}', ignoring paths '#{ignored_paths.join(', ')}' - NB. only internal links will be checked"
    Anemone.crawl("http://#{address}", {delay: delay}) do |anemone|
      crawl_all_pages_for_links(address, anemone, ignored_paths, reporter)
      visit_page_links(anemone, reporter)
    end

    exit_code = reporter.exit_code
    puts "finished (#{exit_code})"
    exit(exit_code)

  end

  def self.crawl_images(address, ignored_paths = [], delay = 0, reporter = InvestigativeReporter.new)
    puts "Website server to check: '#{address}', ignoring paths '#{ignored_paths.join(', ')}' - NB. only internal links will be checked"
    Anemone.crawl("http://#{address}", {delay: delay}) do |anemone|
      crawl_all_pages_for_images(address, anemone, ignored_paths, reporter)
      visit_page_links(anemone, reporter)
    end

    exit_code = reporter.exit_code
    puts "finished (#{exit_code})"
    exit(exit_code)
  end

  def self.crawl_all_pages_for_links(address, anemone, ignored_paths, reporter)
    anemone.focus_crawl { |page|
      puts "#{Time.now}: focus page is #{page.url}"
      report_links_on_page(page, reporter)
      get_relevant_links_on_page(address, ignored_paths, page)
    }
  end

  def self.crawl_all_pages_for_images(address, anemone, ignored_paths, reporter)
    anemone.focus_crawl { |page|
      puts "#{Time.now}: focus page is #{page.url}"
      report_links_on_page(page, reporter)
      report_images_on_page(page, reporter)
      get_relevant_links_on_page(address, ignored_paths, page) + get_relevant_image_links_on_page(address, ignored_paths, page)
    }
  end

  def self.visit_page_links(anemone, reporter)
    anemone.on_every_page { |anemone_page|
      puts "#{Time.now}: visit page is #{anemone_page.url}"
      reporter.on_visit Page.new(anemone_page)
    }
  end

  def self.report_links_on_page(page, reporter)
    page.links.each { |link| reporter.on_see_link(link) }
  end

  def self.report_images_on_page(page, reporter)
    image_links(page).each { |img|
      reporter.on_see_link(img)
    }
  end

  def self.get_relevant_links_on_page(address, ignored_paths, page)
    page.links.select { |uri|
      is_relevant_link?(address, port_number_for(page), ignored_paths, uri)
    }
  end

  def self.get_relevant_image_links_on_page(address, ignored_paths, page)
    image_links(page).select { |uri|
      is_relevant_link?(address, port_number_for(page), ignored_paths, uri)
    }
  end

  def self.image_links(page)
    links = []
    doc = page.doc

    unless doc.nil?
      doc.search('//img[@src]').select { |img|
        links << page.to_absolute(img['src'])
      }
      links
    end
    links
  end

  def self.is_relevant_link?(address, port, ignored_paths, uri)
    Link.new(uri).on_website?(address, port) && !ignored_paths.any? { |path| !!(path =~ uri.path) }
  end

  private

  def self.port_number_for(page)
    if page.url.to_s.include? 'https'
      port = '443'
    else
      port = '80'
    end
    port
  end
end