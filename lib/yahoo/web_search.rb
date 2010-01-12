require 'yahoo/search'

##
# Yahoo Web Search API
#
# http://developer.yahoo.com/search/web/V1/webSearch.html

class Yahoo::WebSearch < Yahoo::Search

  Result = Struct.new :title, :summary, :url, :click_url, :mime_type,
                      :modification_date, :cache_url, :cache_size

  def initialize(*args) # :nodoc:
    @host = 'api.search.yahoo.com'
    @service_name = 'WebSearchService'
    @version = 'V1'
    super
  end

  ##
  # Searches the web for +query+ and returns up to +results+ items.
  #
  # If +results+ is omitted then ten results are returned.
  #
  # For details on constructing +query+, see:
  # http://help.yahoo.com/help/us/ysearch/tips/tips-04.html

  def search(query, results = nil)
    params = { :query => query }
    params[:results] = results unless results.nil?
    get :webSearch, params
  end

  def parse_response(xml) # :nodoc:
    search_results = []

    total_results_available, total_results_returned, first_result_position =
      parse_result_info xml

    xml.elements['ResultSet'].each do |r|
      next if REXML::Text === r
      result = Result.new

      result.title             = r.elements['Title'].text
      result.summary           = r.elements['Summary'].text
      result.url               = URI.parse r.elements['Url'].text
      result.click_url         = URI.parse r.elements['ClickUrl'].text
      result.mime_type         = r.elements['MimeType'].text
      result.modification_date = Time.at r.elements['ModificationDate'].text.to_i
      result.cache_url         = URI.parse r.elements['Cache/Url'].text
      result.cache_size        = r.elements['Cache/Size'].text.to_i

      search_results << result
    end

    return search_results, total_results_available, total_results_returned,
           first_result_position
  end

end

##
# A Result contains the following fields:
#
# +title+:: the title of the web page
# +summary+:: summary text associated with the web page
# +url+:: URL for the web page
# +click_url+:: URL for linking to the page
# +mime_type+:: MIME type of the page
# +modification_date+:: Time the page was last modified
# +cache_url+:: URL of the cached result
# +cache_size+:: size of the cached result in bytes

class Yahoo::WebSearch::Result; end
