require 'vancouver_scraper/scraper'

class ScrapeController < ApplicationController
  include VancouverScraper

  before_action :authenticate_admin!

  def index

  end

  def get_data
    cookie_template = VancouverUtil.get_cookie_template

    category_all_ids = get_volleyball_category_cached

    dropins = Array.new

    category_all_ids.first(5).each do |id|
      dropin = VancouverEvent.new(id, cookie_template, VancouverScraper::DEFAULT_EVENT_URL, :should_parse_location => true)
      dropin.parse
      dropin_schedule = dropin.parse_schedule
      dropin.fields_hash["Schedule"] = dropin_schedule.all_occurrences
      dropin.fields_hash["ScheduleString"] = dropin_schedule.to_s

      dropins.push(dropin)
    end

    render json: dropins
  end

  def get_dropins_by_ids
    cookie_template = VancouverUtil.get_cookie_template

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
  def get_volleyball_category_cached
    category_all_ids = Rails.cache.read("vancouver_volleyball_category")

    if category_all_ids.nil?
      category = VancouverCategory.new(186, VancouverUtil.get_cookie_template)
      category_all_ids = category.all_ids
      Rails.cache.write("vancouver_volleyball_category", category_all_ids)
    end

    return category_all_ids
  end

end
