require_relative 'reporter'

class NoisyReporter < Reporter
  def on_see_link(uri)
    puts "seen: #{uri}"
  end
end