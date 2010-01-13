require 'yahoo'

##
# Abstract class for searching yahoo.

class Yahoo::Search < Yahoo

  VERSION = '2.0.0'

  ##
  # Returns the total results available, returned, and first result position
  # for the returned results.

  def parse_result_info(xml) # :nodoc:
    rs = xml.at_xpath('//xmlns:ResultSet')
    total_results_available = rs['totalResultsAvailable'].to_i
    total_results_returned  = rs['totalResultsReturned'].to_i
    first_result_position   = rs['firstResultPosition'].to_i

    return total_results_available, total_results_returned,
           first_result_position
  end

end

