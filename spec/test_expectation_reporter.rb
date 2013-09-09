require_relative '../lib/reporter'

class TestExpectationReporter < Reporter

  attr_reader :seen_links, :visited_pages

  def initialize
    @seen_links, @visited_pages = [], []
  end

  def on_see_link(uri)
    @seen_links << uri
  end
  def on_visit(page)
    @visited_pages << page
  end
  def exit_code
    0
  end
end