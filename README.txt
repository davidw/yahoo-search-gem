= yahoo-search

Github Project:

http://github.com/davidw/yahoo-search-gem

Documentation:

FIXME

== About

yahoo-search implements version 1 of Yahoo's Web Search service and version 3
of Yahoo's Local Search Web Service.

== Installing yahoo-search

Just install the gem:

  $ sudo gem install yahoo-search

== Using yahoo-search

First you'll need a Yahoo Application ID.  You can register for one here:

http://api.search.yahoo.com/webservices/register_application

Then you create a Yahoo::Search object and start locating places:

  require 'rubygems'
  require 'yahoo/web_search'
  
  ys = Yahoo::WebSearch.new application_id
  results, = ys.search 'madonna'
  results.each do |result|
    puts "#{result.title} at #{result.url}"
  end

  require 'rubygems'
  require 'yahoo/local_search'
  
  yls = Yahoo::LocalSearch.new application_id
  results, = yls.locate 'pizza', 94306, 2
  results.each do |location|
    puts "#{location.title} at #{location.address}, #{location.city}"
  end

