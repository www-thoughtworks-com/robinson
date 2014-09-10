require 'optparse'
require 'ostruct'

class Options

  def parse(args)
    options = OpenStruct.new
    options.delay = 0
    options.threads = 2
    options.ignoring = []

    opt_parser = OptionParser.new do |opts|

      opts.banner = 'Usage: robinson [website_url] [options]'
      opts.separator ''
      opts.separator '  e.g. robinson www.example.com'
      opts.separator '  e.g. robinson localhost:8080 --ignoring ^(?:/..)?/blogs/?.* ^(?:/..)?/products/?.*'
      opts.separator 'options:'

      opts.on('--delay [n]', Float, 'Delay [n] seconds between link checking requests') do |n|
        options.delay = n
      end

      opts.on('--threads [n]', Integer, 'Use [n] threads for sending requests to the target website') do |n|
        options.threads = n
      end

      opts.on('--ignoring [pattern1] [pattern2] [pattern3] ...', String, 'Ignores the list of URLs that match these patterns') do |first_pattern|
        options.ignoring = [first_pattern].concat(args)
      end

      opts.on_tail('-h', '--help', 'Display help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    add_address_from_first_argument(args, options)

    options
  end

  def add_address_from_first_argument(args, options)
    options.address = args[0]
  end
end