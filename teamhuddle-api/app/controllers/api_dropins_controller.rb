class ApiDropinsController < ApplicationController
  
  def index
    from = DateTime.now.beginning_of_day
    to = DateTime.now.end_of_day
    if params[:from].present? and params[:to].present?
      from = Time.parse(params[:from])
      to = Time.parse(params[:to])
    end
    
    #default to volleyball right now
    @sport = String.new("volleyball")
    @sport = params[:sport] if params[:sport].present?

    sport_event_filter_hash = { type: "dropin", sport_id: @sport, deleted_at: nil }
    sport_event_filter_hash[:skill_level] = params[:skill_level] if params[:skill_level].present?
    
    # This is for the API -> see index.json.rabl
    @sport_event_instances = SportEventInstance.includes(:event, :location, :sport_event, :organization)
                                               .between(from, to)
                                               .where( sport_events: sport_event_filter_hash)
    
  end
end
