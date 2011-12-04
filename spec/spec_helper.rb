DIR = File.dirname(__FILE__)+'/../'
$:.unshift(DIR) unless $:.include?(DIR) || $:.include?(File.expand_path(DIR))
require 'lib/parser'
require 'lib/booking'
require 'lib/booking_search'