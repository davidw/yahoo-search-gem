require 'test/unit'
require 'rc_rest/uri_stub'
require 'yahoo/web_search'

class Yahoo::TestWebSearch < Test::Unit::TestCase

  def setup
    URI::HTTP.responses = []
    URI::HTTP.uris = []

    @s = Yahoo::WebSearch.new 'APP_ID'
  end

  def test_search
    URI::HTTP.responses << <<-EOF.strip
<?xml version="1.0" encoding="UTF-8"?>
<ResultSet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:yahoo:srch" xsi:schemaLocation="urn:yahoo:srch http://api.search.yahoo.com/WebSearchService/V1/WebSearchResponse.xsd" totalResultsAvailable="32900000" totalResultsReturned="2" firstResultPosition="1">
<Result><Title>Madonna</Title><Summary>Official site of pop diva Madonna, with news, music, media, and fan club.</Summary><Url>http://www.madonna.com/</Url><ClickUrl>http://uk.wrs.yahoo.com/_ylt=A0Je5VwxLIpEF60ArETdmMwF;_ylu=X3oDMTB2cXVjNTM5BGNvbG8DdwRsA1dTMQRwb3MDMQRzZWMDc3IEdnRpZAM-/SIG=11bs38c7g/EXP=1149992369/**http%3a//www.madonna.com/</ClickUrl><ModificationDate>1145602800</ModificationDate><MimeType>text/html</MimeType>
<Cache><Url>http://uk.wrs.yahoo.com/_ylt=A0Je5VwxLIpEF60AskTdmMwF;_ylu=X3oDMTBwOHA5a2tvBGNvbG8DdwRwb3MDMQRzZWMDc3IEdnRpZAM-/SIG=15igoccah/EXP=1149992369/**http%3a//66.218.69.11/search/cache%3fei=UTF-8%26appid=APP_ID%26query=madonna%26results=2%26u=www.madonna.com/%26w=madonna%26d=BCcdDDmtM3M7%26icp=1%26.intl=us</Url><Size>17777</Size></Cache>
</Result>

<Result><Title>Madonnalicious</Title><Summary>Pictures, articles, downloads, concert info, news, and more about Madonna.</Summary><Url>http://www.madonnalicious.com/</Url><ClickUrl>http://uk.wrs.yahoo.com/_ylt=A0Je5VwxLIpEF60AtETdmMwF;_ylu=X3oDMTB2ZjQ4dDExBGNvbG8DdwRsA1dTMQRwb3MDMgRzZWMDc3IEdnRpZAM-/SIG=11injilpr/EXP=1149992369/**http%3a//www.madonnalicious.com/</ClickUrl><ModificationDate>1149750000</ModificationDate><MimeType>text/html</MimeType>
<Cache><Url>http://uk.wrs.yahoo.com/_ylt=A0Je5VwxLIpEF60AukTdmMwF;_ylu=X3oDMTBwZG5hOWwzBGNvbG8DdwRwb3MDMgRzZWMDc3IEdnRpZAM-/SIG=15pmktjmj/EXP=1149992369/**http%3a//66.218.69.11/search/cache%3fei=UTF-8%26appid=APP_ID%26query=madonna%26results=2%26u=www.madonnalicious.com/%26w=madonna%26d=SuWzgDmtM6lL%26icp=1%26.intl=us</Url><Size>202503</Size></Cache>
</Result>
</ResultSet>
<!-- ws02.search.scd.yahoo.com compressed/chunked Fri Jun  9 19:19:28 PDT 2006 -->
    EOF

    results, avail, returned, position = @s.search 'madonna', 2

    assert_equal 32900000, avail
    assert_equal 2, returned
    assert_equal 1, position

    assert_equal 2, results.length

    result = results.first
    assert_equal 'Madonna', result.title
    assert_equal 'Official site of pop diva Madonna, with news, music, media, and fan club.',
                 result.summary
    assert_equal 'http://www.madonna.com/', result.url.to_s
    assert_equal 'http://uk.wrs.yahoo.com/_ylt=A0Je5VwxLIpEF60ArETdmMwF;_ylu=X3oDMTB2cXVjNTM5BGNvbG8DdwRsA1dTMQRwb3MDMQRzZWMDc3IEdnRpZAM-/SIG=11bs38c7g/EXP=1149992369/**http%3a//www.madonna.com/', 
                 result.click_url.to_s
    assert_equal 'text/html', result.mime_type
    assert_equal Time.at(1145602800), result.modification_date
    assert_equal 'http://uk.wrs.yahoo.com/_ylt=A0Je5VwxLIpEF60AskTdmMwF;_ylu=X3oDMTBwOHA5a2tvBGNvbG8DdwRwb3MDMQRzZWMDc3IEdnRpZAM-/SIG=15igoccah/EXP=1149992369/**http%3a//66.218.69.11/search/cache%3fei=UTF-8%26appid=APP_ID%26query=madonna%26results=2%26u=www.madonna.com/%26w=madonna%26d=BCcdDDmtM3M7%26icp=1%26.intl=us',
                 result.cache_url.to_s
    assert_equal 17777, result.cache_size

    assert_equal true, URI::HTTP.responses.empty?
    assert_equal 1, URI::HTTP.uris.length
    assert_equal 'http://api.search.yahoo.com/WebSearchService/V1/webSearch?appid=APP_ID&output=xml&query=madonna&results=2',
                 URI::HTTP.uris.first
  end

end

