require 'hoe'

require './lib/yahoo/search'

DEV_DOC_PATH = 'Libraries/yahoo-search'

hoe = Hoe.new 'yahoo-search', Yahoo::Search::VERSION do |p|
  p.summary = 'A Ruby Yahoo Search API Implementation'
  p.description = 'An interface to Yahoo\'s Search services.'
  p.author = 'Eric Hodel'
  p.email = 'drbrain@segment7.net'
  p.url = "http://dev.robotcoop.com/#{DEV_DOC_PATH}"
  p.changes = File.read('History.txt').scan(/\A(=.*?)^=/m).first.first
  p.rubyforge_name = 'rctools'

  p.extra_deps << ['yahoo', '>= 1.1.1']
end

SPEC = hoe.spec

begin
  require '../tasks'
rescue LoadError
end

# vim: syntax=Ruby

