#!/bin/ruby

require 'patron'
require 'nokogiri'

http = Patron::Session.new
base = ARGV.first.to_s
http.base_url = base
puts "base: '#{base}'"
puts http.get('/').body
