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
    
    # This is for the API -> see index.json.rabl
    @sport_event_instances = SportEventInstance.includes(:event, :location, :sport_event, :organization)
                                               .between(from, to)
                                               .where( sport_events: { type: "dropin", sport_id: @sport, deleted_at: nil })
    
  end
end
