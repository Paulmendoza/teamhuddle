module VancouverScraper

  class VancouverCategory
    attr_accessor(:html_doc)
    attr_accessor(:response)
    attr_accessor(:post_response)
    attr_accessor(:first_url)
    attr_accessor(:category_url)
    attr_accessor(:prev_page)
    attr_accessor(:all_ids)

    def initialize(category_id, cookies)

      @all_ids = Array.new
      # Step 1:
      #     Do post to
      # ActivityDirectoryFrame.sdi
      # see saved post on chrome webtool

      @cookies = cookies

      @category_url = 'https://pbregister.vancouver.ca/ActivityDirectoryFrame.sdi'

      puts 'Posting to ' + @category_url
      @post_response = RestClient::Request.execute(:url => @category_url,
                                                   :method => :post,
                                                   :verify_ssl => false,
                                                   :payload => {:ca => category_id},
                                                   :cookies => @cookies)

      puts '..Done'
      # Step 2:
      #     do get to
      # ActivityDirectoryDetail.sdi?errormsg=
      #                                 this will give html of links
      @first_url = 'https://pbregister.vancouver.ca/ActivityDirectoryDetail.sdi?errormsg='
      @next_url = 'https://pbregister.vancouver.ca/ActivityDirectoryFrame.sdi?dir=n'

      puts 'Getting first page from ' + @first_url

      @response = ''

      @prev_page = RestClient::Request.execute(:url => @first_url,
                                               :method => :get,
                                               :verify_ssl => false,
                                               :cookies => @cookies)
      parse_page(Nokogiri::HTML(@prev_page))
      puts '..Parsed first page'

      #
      # Step 3:
      #     go through all the pages using GET to
      #
      # ActivityDirectoryFrame.sdi?dir=n
      # keep going until the page is not the same as the last one...

      puts 'Begin looping'
      while @prev_page != @response
        puts 'Getting next page..'
        @prev_page = @response

        # advance server cursor :)

        RestClient::Request.execute(:url => @next_url,
                                    :method => :get,
                                    :verify_ssl => false,
                                    :cookies => @cookies)

        # now lets get another list :)
        @response = RestClient::Request.execute(:url => @first_url,
                                                :method => :get,
                                                :verify_ssl => false,
                                                :cookies => @cookies)
        parse_page(Nokogiri::HTML(@response))
        puts 'Parsed'
      end

      puts '..Done'

      @html_doc = Nokogiri::HTML(@response)

      puts 'so far so good'

    end

    # Parses the html doc for the ids
    def parse_page(html_doc)
      html_doc.css("a").each do |link|

        # regex to capture just the id
        capture = /adet\.sdi\?activity_id=\s*(.*\d)/.match(link['href'])

        unless capture.nil?
          puts capture[1] + ' added to array'
          @all_ids.push(capture[1].to_i)
        end

      end
    end
  end
end

