require_dependency 'vancouver_scraper/scraper'

class ScrapeController < ApplicationController
  include VancouverScraper
  def index

  end

  def get_data
    cookie_template = VancouverUtil.get_cookie_template()

    category = VancouverCategory.new(186, cookie_template)

    dropins = Array.new

    category.all_ids.first(5).each do |id|
      dropin = VancouverEvent.new(id, cookie_template, VancouverScraper::DEFAULT_EVENT_URL, :should_parse_location => true)
      dropin.parse
      dropins.push(dropin)
    end

    render json: dropins
  end

  def get_ids

  end
end
