require 'test/unit'
require 'rubygems'
require 'rc_rest/uri_stub'
require 'yahoo/local_search'

class Yahoo::TestLocalSearch < Test::Unit::TestCase

  def setup
    URI::HTTP.responses = []
    URI::HTTP.uris = []

    @s = Yahoo::LocalSearch.new 'APP_ID'
  end

  def test_search
    URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0"?>
<ResultSet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:yahoo:lcl" xsi:schemaLocation="urn:yahoo:lcl http://api.local.yahoo.com/LocalSearchService/V3/LocalSearchResponse.xsd" totalResultsAvailable="431" totalResultsReturned="2" firstResultPosition="1"><ResultSetMapUrl>http://local.yahoo.com/mapview?stx=pizza&amp;csz=Palo+Alto%2C+CA+94306&amp;city=Palo+Alto&amp;state=CA&amp;radius=15&amp;ed=BVD56a131DxIV6V7_5O_wO8KQY1.bxtOAd8qew--</ResultSetMapUrl><Result id="21395990"><Title>Round Table Pizza Palo Alto</Title><Address>3407 Alma St</Address><City>Palo Alto</City><State>CA</State><Phone>(650) 494-2928</Phone><Latitude>37.419862</Latitude><Longitude>-122.126129</Longitude><Rating><AverageRating>NaN</AverageRating><TotalRatings>0</TotalRatings><TotalReviews>0</TotalReviews><LastReviewDate>0</LastReviewDate><LastReviewIntro></LastReviewIntro></Rating><Distance>0.19</Distance><Url>http://local.yahoo.com/details?id=21395990&amp;stx=pizza&amp;csz=Palo+Alto+CA&amp;ed=OtVQW6160SwBXrynJIx8rirX3iaOtFHwFBC480.oEQVLaK1tM9x1WN.BrJASDzg2asPklg--</Url><ClickUrl>http://local.yahoo.com/details?id=21395990&amp;stx=pizza&amp;csz=Palo+Alto+CA&amp;ed=OtVQW6160SwBXrynJIx8rirX3iaOtFHwFBC480.oEQVLaK1tM9x1WN.BrJASDzg2asPklg--</ClickUrl><MapUrl>http://maps.yahoo.com/maps_result?name=Round+Table+Pizza+Palo+Alto&amp;desc=6504942928&amp;csz=Palo+Alto+CA&amp;qty=9&amp;cs=9&amp;ed=OtVQW6160SwBXrynJIx8rirX3iaOtFHwFBC480.oEQVLaK1tM9x1WN.BrJASDzg2asPklg--&amp;gid1=21395990</MapUrl><BusinessUrl>http://www.roundtablepizza.com/</BusinessUrl><BusinessClickUrl>http://www.roundtablepizza.com/</BusinessClickUrl><Categories><Category id="96926243">Pizza</Category><Category id="96926236">Restaurants</Category></Categories></Result><Result id="21395062"><Title>Papa Murphys Pizza Take &amp; Bake</Title><Address>2730 Middlefield Rd</Address><City>Palo Alto</City><State>CA</State><Phone>(650) 328-5200</Phone><Latitude>37.433243</Latitude><Longitude>-122.129291</Longitude><Rating><AverageRating>4</AverageRating><TotalRatings>8</TotalRatings><TotalReviews>5</TotalReviews><LastReviewDate>1140036645</LastReviewDate><LastReviewIntro>Great place to have pizza with the family.</LastReviewIntro></Rating><Distance>0.99</Distance><Url>http://local.yahoo.com/details?id=21395062&amp;stx=pizza&amp;csz=Palo+Alto+CA&amp;ed=0runZK160SyuzGmb4f1aQLs1KJTXAH56bJ_0HffsK.rhcWN62yU_7KJzff4AZ8TX2LILpT.nu6KJiQQ-</Url><ClickUrl>http://local.yahoo.com/details?id=21395062&amp;stx=pizza&amp;csz=Palo+Alto+CA&amp;ed=0runZK160SyuzGmb4f1aQLs1KJTXAH56bJ_0HffsK.rhcWN62yU_7KJzff4AZ8TX2LILpT.nu6KJiQQ-</ClickUrl><MapUrl>http://maps.yahoo.com/maps_result?name=Papa+Murphys+Pizza+Take+%26amp%3B+Bake&amp;desc=6503285200&amp;csz=Palo+Alto+CA&amp;qty=9&amp;cs=9&amp;ed=0runZK160SyuzGmb4f1aQLs1KJTXAH56bJ_0HffsK.rhcWN62yU_7KJzff4AZ8TX2LILpT.nu6KJiQQ-&amp;gid1=21395062</MapUrl><BusinessUrl>http://www.papamurphys.com/</BusinessUrl><BusinessClickUrl>http://www.papamurphys.com/</BusinessClickUrl><Categories><Category id="96926242">Fast Food</Category><Category id="96926234">Carry Out &amp; Take Out</Category><Category id="96926243">Pizza</Category><Category id="96926236">Restaurants</Category></Categories></Result></ResultSet>
<!-- ws02.search.scd.yahoo.com compressed/chunked Fri Jun  9 10:53:31 PDT 2006 -->
    EOF

    results, map_url, avail, returned, position = @s.locate('pizza', 94306, 2)

    assert_equal 'http://local.yahoo.com/mapview?stx=pizza&csz=Palo+Alto%2C+CA+94306&city=Palo+Alto&state=CA&radius=15&ed=BVD56a131DxIV6V7_5O_wO8KQY1.bxtOAd8qew--',
                 map_url.to_s
    assert_equal 431, avail
    assert_equal 2, returned
    assert_equal 1, position

    assert_equal 2, results.length

    result = results.first
    assert_equal 21395990, result.id
    assert_equal 'Round Table Pizza Palo Alto', result.title
    assert_equal '3407 Alma St', result.address
    assert_equal 'Palo Alto', result.city
    assert_equal 'CA', result.state
    assert_equal '(650) 494-2928', result.phone
    assert_equal 37.419862, result.latitude
    assert_equal(-122.126129, result.longitude)
    assert_equal [37.419862, -122.126129], result.coordinates

    assert_equal 0.19, result.distance

    categories = { 'Pizza' => 96926243, 'Restaurants' => 96926236 }

    assert_equal categories, result.categories

    assert_equal 'http://local.yahoo.com/details?id=21395990&stx=pizza&csz=Palo+Alto+CA&ed=OtVQW6160SwBXrynJIx8rirX3iaOtFHwFBC480.oEQVLaK1tM9x1WN.BrJASDzg2asPklg--',
                 result.url.to_s
    assert_equal 'http://local.yahoo.com/details?id=21395990&stx=pizza&csz=Palo+Alto+CA&ed=OtVQW6160SwBXrynJIx8rirX3iaOtFHwFBC480.oEQVLaK1tM9x1WN.BrJASDzg2asPklg--',
                 result.click_url.to_s
    assert_equal 'http://maps.yahoo.com/maps_result?name=Round+Table+Pizza+Palo+Alto&desc=6504942928&csz=Palo+Alto+CA&qty=9&cs=9&ed=OtVQW6160SwBXrynJIx8rirX3iaOtFHwFBC480.oEQVLaK1tM9x1WN.BrJASDzg2asPklg--&gid1=21395990',
                 result.map_url.to_s
    assert_equal 'http://www.roundtablepizza.com/',
                 result.business_url.to_s
    assert_equal 'http://www.roundtablepizza.com/',
                 result.business_click_url.to_s

    result = results.last
    assert_equal 4.0, result.average_rating
    assert_equal 8, result.total_ratings
    assert_equal 5, result.total_reviews
    assert_equal Time.at(1140036645), result.last_review_date
    assert_equal 'Great place to have pizza with the family.',
                 result.last_review_intro

    assert_equal true, URI::HTTP.responses.empty?
    assert_equal 1, URI::HTTP.uris.length
    assert_equal 'http://api.local.yahoo.com/LocalSearchService/V3/localSearch?appid=APP_ID&location=94306&output=xml&query=pizza&results=2',
                 URI::HTTP.uris.first
  end

end

