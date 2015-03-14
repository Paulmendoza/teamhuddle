module VancouverScraper

  class VancouverEvent < VancouverBase
    # Sample Link
    # https://pbregister.vancouver.ca/adet.sdi?activity_id=
    include IceCube

    attr_accessor(:centre)
    attr_accessor(:facility)
    attr_accessor(:should_parse_location)
    attr_accessor(:should_save_location)
    attr_accessor(:is_parsed)

    REQUIRED_KEYS = ['Price',
                     'Meeting dates',
                     'Meeting times',
                     'Category',
                     'Activity #',
                     'Registration opens',
                     'Status',
                     'Ages',
                     'Location Links',
                     'Centre Id',
                     'Facility Id',
                     'Gender',
                     'Instructor',
                     'Supervisor',
                     'Sessions',
                     'Season']

    def initialize(id, cookies, root_url, options = {})
      super(id, cookies, root_url)
      self.is_parsed = false
      self.should_parse_location = options[:should_parse_location] || false
      self.should_save_location = options[:should_save_location] || false
    end

    def parse
      @fields_hash['id'] = @id

      #Title
      @fields_hash['Title'] = @html_doc.at_css(".transparentheading").content
      # Description
      @fields_hash['Description'] = @html_doc.at_css("caption").content

      @html_doc.css("tr").each do |row|
        key = row.at_css("th").text.strip!

        # if it's the location, save the location links explicitly
        if key == 'Location'
          @fields_hash['Location Links'] = row.css("a").map { |link| link['href'] }

          parse_centre_id unless @fields_hash['Location Links'].nil?
          parse_facility_id unless @fields_hash['Location Links'].nil?
        elsif key != 'Activity Detail'
          @fields_hash[key] = row.at_css("td").text
        end
      end

      parse_location if self.should_parse_location

      self.is_parsed = true
      # save_location if self.should_save_location
    end

    def parse_centre_id
      @fields_hash['Centre Id'] = nil

      # grab the first centre id in the array of links
      @fields_hash['Location Links'].each do |link|
        if link.include? 'center_id'
          @fields_hash['Centre Id'] = /\d+/.match(link)[0].to_i
          break
        end
      end
    end

    def parse_facility_id
      @fields_hash['Facility Id'] = nil

      # grab the first centre id in the array of links
      @fields_hash['Location Links'].each do |link|
        if link.include? 'facility_id'
          @fields_hash['Facility Id'] = /\d+/.match(link)[0].to_i
          break
        end
      end
    end

    def parse_location
      self.centre = VancouverCentre.new(self.fields_hash['Centre Id'], self.cookies, DEFAULT_CENTRE_URL)
      self.centre.parse
      self.facility = VancouverFacility.new(self.fields_hash['Facility Id'], self.cookies, DEFAULT_FACILITY_URL)
      self.facility.parse
    end

    def get_price_per_season
      if self.is_parsed
        potential_price = Float(/\d+.\.\d+/.match(@fields_hash['Price'])[0])
        return potential_price unless potential_price.nil? || (potential_price < 20)
      end
    end

    def get_price_per_one
      if self.is_parsed
        # try and parse the dropin price from description (usually)
        potential_price = /\$([0-9]+\.[0-9]+)|\$([0-9])/.match(@fields_hash['Description'])

        potential_price.captures.each do |capture|
          return Float(capture) unless capture.nil?
        end unless potential_price.nil?
      end
    end

    def get_num_of_session
      if self.is_parsed
        # figure our how many sessions there are, divide the price per season by price per session
        num_sessions = get_price_per_season / get_price_per_one
        return num_sessions unless num_sessions.nil?
      end
    end

    def parse_schedule
      # Documentation for IceCube
      # https://github.com/seejohnrun/ice_cube
      # http://seejohncode.com/ice_cube/
      if self.is_parsed


        temp_schedule = nil

        # Check if the first word is Each or not to pick a case
        if /(Each)/.match(@fields_hash['Meeting dates']).nil?
          weekday_a = /\w+/.match(@fields_hash['Meeting dates']).to_s
          weekday_b = /(?<=(#{weekday_a}\-))\w+/.match(@fields_hash['Meeting dates']).to_s
          testing_array = (@fields_hash['Meeting dates']).to_s.scan(/\,\s(\w+\s[0-9]+)/)

          month_a = /\w+/.match(testing_array[0].to_s).to_s
          month_a_day = /[0-9]+/.match(testing_array[0].to_s).to_s
          month_b = /\w+/.match(testing_array[1].to_s).to_s
          month_b_day = /[0-9]+/.match(testing_array[1].to_s).to_s

          temp_schedule = IceCube::Schedule.new(Date.new(Date.today.year, Date::MONTHNAMES.index(month_a), month_a_day.to_i))
          temp_schedule.add_recurrence_rule Rule.weekly
                                                .day(day_filler(weekday_a.downcase.to_sym, weekday_b.downcase.to_sym))
                                                .until(Date.new(Date.today.year, Date::MONTHNAMES.index(month_b), month_b_day.to_i))

          # Case 2 : Monday-Friday from Monday, March 9 to Friday, March 13.
          # Multiple days of week with range
        else
          # Case 1 :Each Saturday from January 10 to March 6.
          # One day of week with range
          day = /(?<=(Each\s))\w+/.match(@fields_hash['Meeting dates']).to_s

          date_a_month = /(?<=(from\s))\w+/.match(@fields_hash['Meeting dates']).to_s
          date_a_day = /(?<=(#{date_a_month}\s))[0-9]+/.match(@fields_hash['Meeting dates']).to_s
          date_b_month = /(?<=(to\s))\w+/.match(@fields_hash['Meeting dates']).to_s
          date_b_day = /(?<=(#{date_b_month}\s))[0-9]+/.match(@fields_hash['Meeting dates']).to_s

          temp_schedule = IceCube::Schedule.new(Date.new(Date.today.year, Date::MONTHNAMES.index(date_a_month), date_a_day.to_i))

          temp_schedule.add_recurrence_rule Rule.weekly
                                                .day(day.downcase.to_sym)
                                                .until(Date.new(Date.today.year, Date::MONTHNAMES.index(date_b_month), date_b_day.to_i))
        end

        return temp_schedule
        # Case 3 : ...except for the following dates:Mon, February 9, 2015

      end
    end

    def day_filler(day_a, day_b)
      # example... day_a is monday and day_b is wednesday, the array would have :monday,:tuesday, :wednesday
      temp_week_array = [day_a]
      current = day_a
      while current != day_b do
        case current
          when :monday
            temp_week_array.push(:tuesday)
            current = :tuesday
          when :tuesday
            temp_week_array.push(:wednesday)
            current = :wednesday
          when :wednesday
            temp_week_array.push(:thursday)
            current = :thursday
          when :thursday
            temp_week_array.push(:friday)
            current = :friday
          when :friday
            temp_week_array.push(:saturday)
            current = :saturday
          when :saturday
            temp_week_array.push(:sunday)
            current = :sunday
          when :sunday
            temp_week_array.push(:monday)
            current = :monday
        end
      end
      return temp_week_array
    end
  end
end

