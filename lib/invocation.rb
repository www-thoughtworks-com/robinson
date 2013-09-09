require_relative '../lib/robinson'

class Invocation
  def initialize(args)
    @address = args.first || ''
    @ignoring_pages = args.include? '--ignoring'
    @ignored_pages = args.slice(2..(args.size)).map { |string| Regexp.new(string) } || []
  end

  def execute
    check_args
    Robinson.crawl @address, @ignored_pages
  end

  private
  def check_args
    if @address.include? '/' then usage('only accepts website server host[:port], not paths') end
    if @address.empty? then usage('you need to pass in the website server host[:port]') end
    if @ignoring_pages
      usage('you need to specify the paths of the pages to ignore') if @ignored_pages.empty?
    end
  end

  def usage weirdness = ''
    if weirdness.length > 0
      puts "\nSorry, #{weirdness}\n\n"
    end
    puts 'Usage: robinson <host>[:<port>] [--ignoring <ignoreregex> [...]'
    puts '  e.g. robinson www.example.com'
    puts '  e.g. robinson localhost:8080 --ignoring ^(?:/..)?/blogs/?.* ^(?:/..)?/products/?.*'
    exit 1
  end
end

def robinson_main(arguments)
  Invocation.new(arguments).execute
end