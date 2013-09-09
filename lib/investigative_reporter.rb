require 'reporter'

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