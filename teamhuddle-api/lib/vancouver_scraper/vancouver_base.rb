module VancouverScraper

  class VancouverBase
    attr_accessor(:html_doc)
    attr_accessor(:fields_hash)
    attr_accessor(:id)
    attr_accessor(:cookies)
    attr_accessor(:url)
    attr_accessor(:response)
    attr_accessor(:save_errors)

    def initialize(id, cookies, root_url)
      @id = id
      @cookies = cookies
      @fields_hash = Hash.new
      @save_errors = Array.new

      @url = root_url + id.to_s

      @response = RestClient::Request.execute(:url => @url,
                                              :method => :get,
                                              :verify_ssl => false,
                                              :cookies => @cookies)

      @html_doc = Nokogiri::HTML(@response)
    end

    # Each vancouver_scraper class should override this method for all of its scraping logic
    # (selectors through Nokogiri)
    def parse;
      "Parsing method";
    end

  end
end