require 'yahoo'

##
# Abstract class for searching yahoo.

class Yahoo::Search < Yahoo

  VERSION = '1.1.1'

  ##
  # Returns the total results available, returned, and first result position
  # for the returned results.

  def parse_result_info(xml) # :nodoc:
    rs = xml.elements['ResultSet']
    total_results_available = rs.attributes['totalResultsAvailable'].to_i
    total_results_returned  = rs.attributes['totalResultsReturned'].to_i
    first_result_position   = rs.attributes['firstResultPosition'].to_i

    return total_results_available, total_results_returned,
           first_result_position
  end

end

