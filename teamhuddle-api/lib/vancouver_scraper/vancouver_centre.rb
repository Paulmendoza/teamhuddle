module VancouverScraper

  class VancouverCentre < VancouverBase
    #centre https://pbregister.vancouver.ca/cD.sdi?center_id=247
    REQUIRED_KEYS = ['id',
                     'Name',
                     'Facility Ids', #parsed into ints already
                     'Address',
                     'Supervisor',
                     'Parking Capacity',
                     'Phone',
                     'Size',
                     'ADA Compliance',
                     'Monday',
                     'Tuesday',
                     'Wednesday',
                     'Thursday',
                     'Friday',
                     'Saturday',
                     'Sunday']

    def parse
      @fields_hash['id'] = @id

      @fields_hash['Name'] = @html_doc.css("td tr:nth-child(1) tr .sectionpad font").text.strip

      @fields_hash['Facility Ids'] = Array.new

      # Loop through Even columns first first
      @html_doc.css(".altRowEven").each do |row|

        #if there is no header, it means it's a list of facilities. parse accordingly
        if row.at_css("th").nil?
          # Regex facility ids from link and convert them to ints
          @fields_hash['Facility Ids'] = row.css("a").map { |link| /\d+/.match(link['href'])[0].to_i }
        else # else just parse it like a table
          @fields_hash[row.at_css("th").text] = row.at_css("td").text.strip
        end

      end

      # Loop through each odd
      @html_doc.css(".altRowOdd").each do |row|

        #if there is no header, it means it's a list of facilities. parse accordingly
        if row.at_css("th").nil?
          # Regex facility ids from link and convert them to ints
          @fields_hash['Facility Ids'] = row.css("a").map { |link| /\d+/.match(link['href'])[0].to_i }
        else # else just parse it like a table
          @fields_hash[row.at_css("th").text] = row.at_css("td").text.strip
        end

      end
    end
  end
end