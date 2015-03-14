module VancouverScraper

  DEFAULT_EVENT_URL = 'https://pbregister.vancouver.ca/adet.sdi?activity_id='
  DEFAULT_CENTRE_URL = 'https://pbregister.vancouver.ca/cD.sdi?center_id='
  DEFAULT_FACILITY_URL = 'https://pbregister.vancouver.ca/fD.sdi?facility_id='

  class VancouverUtil
    def self.get_cookie_template
      RestClient::Request.execute(:url => 'https://pbregister.vancouver.ca/adet.sdi?activity_id=519077', :method => :get, :verify_ssl => false).cookies
    end
  end
end