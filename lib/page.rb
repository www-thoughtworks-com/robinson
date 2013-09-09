require 'smart_colored'

class Page
  def initialize(anemone_page)
    @page = anemone_page
  end
  def puts
    if unfetchable?
      $stdout.puts(pagelog("BROKEN!!", 'no http response').colored.red)
    elsif broken?
      $stdout.puts(pagelog("BROKEN!!", @page.code).colored.red)
    else
      $stdout.puts(pagelog("checked", @page.code).colored.green)
    end
  end
  def pagelog(what, code)
    "#{what}: #{@page.url} - #{code} (referer: #{@page.referer})"
  end
  def unfetchable?
    @page.code.nil?
  end
  def broken?
    if unfetchable?
      return true
    end
    @page.code >= 400
  end

  def url
    @page.url
  end
end