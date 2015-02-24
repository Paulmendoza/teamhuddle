require 'vancouver_scraper/scraper'

class ScrapeController < ApplicationController
  include VancouverScraper

  before_action :authenticate_admin!

  def index

  end

  def get_dropins_by_ids
    cookie_template = get_cookie_session_cached.cookie

    dropin_ids = params['dropinIds']

    dropins = Array.new

    dropin_ids.each do |id|
      int_id = id.to_i
      dropin = VancouverEvent.new(int_id, cookie_template, VancouverScraper::DEFAULT_EVENT_URL, :should_parse_location => true)
      dropin.parse
      #dropin_schedule = dropin.parse_schedule
      #dropin.fields_hash["Sche  dule"] = dropin_schedule.all_occurrences
      #dropin.fields_hash["ScheduleString"] = dropin_schedule.to_s

      dropins.push(dropin)
    end

    render json: dropins
  end

  def get_ids_by_category
    render json: VancouverCategory.new(params[:id].to_i, VancouverUtil.get_cookie_template)
  end

  private
  def get_cookie_session_cached
    cookie = Rails.cache.read("vancouver_scraper_cookie")

    if cookie.nil? || !cookie.is_a?(CachedCookie) || cookie.dt_cached < DateTime.now.advance(minutes: -30)
      cookie = CachedCookie.new(VancouverUtil.get_cookie_template)
      Rails.cache.write("vancouver_scraper_cookie", cookie)
    end

    return cookie
  end

  class CachedCookie
    attr_accessor(:cookie)
    attr_accessor(:dt_cached)

    def initialize(cookie)
      self.cookie = cookie
      self.dt_cached = DateTime.now
    end
  end

end
