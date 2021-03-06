require 'yahoo/search'

##
# Yahoo local search API.
#
# http://developer.yahoo.com/search/local/V3/localSearch.html

class Yahoo::LocalSearch < Yahoo::Search

  ##
  # Local search result struct.

  Result = Struct.new :id, :title, :address, :city, :state, :phone,
                      :latitude, :longitude,

                      :average_rating, :total_ratings, :total_reviews,
                      :last_review_date, :last_review_intro,

                      :distance,

                      :url, :click_url, :map_url, :business_url,
                      :business_click_url,

                      :categories

  def initialize(*args) # :nodoc:
    @host = 'api.local.yahoo.com'
    @service_name = 'LocalSearchService'
    @version = 'V3'
    super
  end

  ##
  # Search for +query+ at +location+ and return up to +results+ items.
  #
  # If +results+ is omitted then ten results are returned.
  #
  # +query+ is the location you are searching for.
  #
  # +location+ can be any of
  # * city, state
  # * city, state, zip
  # * zip
  # * street, city, state
  # * street, city, state, zip
  # * street, zip
  #
  # locate returns five items, an Array of search results, a URI for a webpage
  # with a map of the search results, the total number of results available,
  # the number of results returned and the position of the first result in the
  # overall search (one based).

  def locate(query, location, results = nil)
    params = { :query => query, :location => location }
    params[:results] = results unless results.nil?
    get :localSearch, params
  end

  def parse_response(xml) # :nodoc:
    search_results = []

    result_set_map_url = URI.parse(xml.at_xpath('//xmlns:ResultSetMapUrl').content)
    total_results_available, total_results_returned, first_result_position =
      parse_result_info(xml)

    xml.xpath('//xmlns:Result').each do |r|
      sr = Result.new

      sr.id        = r['id'].to_i
      sr.title     = r.at_xpath('xmlns:Title').content
      sr.address   = r.at_xpath('xmlns:Address').content
      sr.city      = r.at_xpath('xmlns:City').content
      sr.state     = r.at_xpath('xmlns:State').content
      sr.phone     = r.at_xpath('xmlns:Phone').content
      sr.latitude  = r.at_xpath('xmlns:Latitude').content.to_f
      sr.longitude = r.at_xpath('xmlns:Longitude').content.to_f

      rating = r.at_xpath('xmlns:Rating')
      sr.average_rating    = rating.at_xpath('xmlns:AverageRating').content.to_f
      sr.total_ratings     = rating.at_xpath('xmlns:TotalRatings').content.to_i
      sr.total_reviews     = rating.at_xpath('xmlns:TotalReviews').content.to_i
      sr.last_review_date  = Time.at rating.at_xpath('xmlns:LastReviewDate').content.to_i
      sr.last_review_intro = rating.at_xpath('xmlns:LastReviewIntro').content

      sr.distance           = r.at_xpath('xmlns:Distance').content.to_f
      sr.url                = URI.parse r.at_xpath('xmlns:Url').content
      sr.click_url          = URI.parse r.at_xpath('xmlns:ClickUrl').content
      sr.map_url            = URI.parse r.at_xpath('xmlns:MapUrl').content
      sr.business_url       = URI.parse r.at_xpath('xmlns:BusinessUrl').content
      sr.business_click_url = URI.parse r.at_xpath('xmlns:BusinessClickUrl').content

      sr.categories = {}
      r.xpath('.//xmlns:Category').each do |c|
        sr.categories[c.content] = c['id'].to_i
      end

      search_results << sr
    end

    return search_results, result_set_map_url, total_results_available,
           total_results_returned, first_result_position
  end

end

##
# A Result contains the following fields:
#
# +id+:: The id of this result.
# +title+:: The name of the result
# +address+:: Street address of the result
# +city+:: City in which the result is located
# +state+:: State in which the result is located
# +phone+:: Phone number, if known
# +latitude+:: Latitude of the location
# +longitude+:: Longitude of the location
# +average_rating+:: Average score of end-user ratings for the business or
#                    service
# +total_ratings+:: Total number of ratings submitted for the business or
#                   service
# +total_reviews+:: Total number of ratings submitted for the business or
#                   service
# +last_review_date+:: Time of the last review submitted for the business or
#                      service
# +last_review_intro+:: The first few words of the last review submitted for
#                       the business or service
# +distance+:: Distance from the search location to this business or service
# +url+:: URL to the detailed page for a business
# +click_url+:: URL for linking to the detailed page for a business
# +map_url+:: URL for a map of the address
# +business_url+:: URL of the businesses website, if known
# +business_click_url+:: URL for linking to the businesses website, if known
# +categories+:: Hash of category names and category ids for this result

class Yahoo::LocalSearch::Result

  ##
  # Returns an Array with latitude and longitude.

  def coordinates
    return [latitude, longitude]
  end

end

