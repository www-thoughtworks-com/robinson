require_relative 'robinson'
require_relative 'options'

class Invocation
  def initialize(args)
    @args = args
  end

  def execute
    begin
      options = Options.new.parse(@args)
      Robinson.crawl options.address, options.ignoring.map { |string| Regexp.new(string) },options.delay
    rescue Exception => ex
      $stderr.write 'Error: ' + ex.message
      exit 1
    end
  end

end

def robinson_main(arguments)
  Invocation.new(arguments).execute
end