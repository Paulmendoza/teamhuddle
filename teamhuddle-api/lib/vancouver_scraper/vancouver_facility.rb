module VancouverScraper

  class VancouverFacility < VancouverBase
    #facility https://pbregister.vancouver.ca/fD.sdi?facility_id=2359

    REQUIRED_KEYS = [
        'id',
        'Name',
        'Location',
        'Supervisor',
        'Minimum Capacity',
        'Part of Larger Rental Facility',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
        'Phone',
        'Amenities',
        'Maximum Capacity',
        'Rental Facility Ids'
    ]

    def parse
      @fields_hash['id'] = @id

      @fields_hash['Name'] = @html_doc.css("td tr:nth-child(1) tr .sectionpad font").text.strip

      # Loop through Even columns first first
      @html_doc.css(".altRowEven").each do |row|
        @fields_hash[row.at_css("th").text] = row.at_css("td").text.strip
      end

      # Loop through each odd
      @html_doc.css(".altRowOdd").each do |row|
        col_name = row.at_css("th").text

        if col_name == 'Designated Rental Areas within this Facility'
          @fields_hash['Rental Facility Ids'] = row.css("a").map { |link| /\d+/.match(link['href']).to_s }
        else
          @fields_hash[row.at_css("th").text] = row.at_css("td").text.strip
        end
      end
    end
  end
end
