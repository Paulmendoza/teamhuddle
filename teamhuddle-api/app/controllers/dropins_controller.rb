class DropinsController < ApplicationController
  include IceCube

  before_action :authenticate_admin!

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
    
    
    # This is for the admin page -> see index.erb
    @dropins = SportEvent.joins(:event).where( sport_events: { type: "dropin", sport: @sport}).select("*")
    
    
    #active = false
    #active = params[:active] if params[:active].present?
    #dropin.schedule.occurring_between?(Time.now, Time.new('2100'))
    
    
  end
  
  def show
    @dropin = SportEvent.joins(:event).where( events: { id: params[:id]}).select('*')
    
    respond_to do |format|
      format.html { render json: @dropin }
      format.json { render json: @dropin, :except => [:event_id] }
      format.xml { render xml: @dropin, except: [:event_id] }
    end
  end

  def create
    # hash to convert form data to symbols for IceCube
    days_of_the_week = {
      'mo' => :monday,
      'tu' => :tuesday,
      'we' => :wednesday,
      'th' => :thursday,
      'fr' => :friday,
      'sa' => :saturday,
      'su' => :sunday
    }
    
    # get the start date and end date NOTE: adds time as well to startime
    start_date = Time.new(params[:start_date][:year], params[:start_date][:month], params[:start_date][:day], 
      params[:start_time][:hour], params[:start_time][:minute])
    end_date = Time.new(params[:end_date][:year], params[:end_date][:month], params[:end_date][:day])
      
    # create a new schedule setting the duration
    schedule = Schedule.new(start_date, :end_time => start_date.change(hour: params[:end_time][:hour], min: params[:end_time][:minute])) do |s|
      # add weekly recurrence ruling based on the day of the week selected
      s.add_recurrence_rule(Rule.weekly.day(days_of_the_week[params[:day]]).until(end_date))
    end
    
    dropin = Dropin.new(params[:dropin][:name],
      params[:dropin][:location_id],
      params[:dropin][:organization_id],
      params[:dropin][:comments],
      params[:dropin][:sport],
      params[:price_per_one],
      params[:skill_level],
      schedule)
    
    
    if dropin.errors.count > 0 
      render json: { error: dropin.errors }, :status => :unprocessable_entity
    else
      respond_to do |format|
        format.json { render json: @dropin }
        format.html { redirect_to action: 'index' }
      end
    
    end
    
  end
  
  def new
    @locations = Location.all
  end

  def edit
  end

  def update
  end
  
  def import
    
  end
  
  def scrape
    # get a response from the API
    response = RestClient.get params[:api_url]
    
    # turn the JSON response into a hash
    response = JSON.parse(response)
    
    @events = []
    
    days_of_the_week = ['monday', 'tuesday', 'wednesday', 
      'thursday', 'friday', 'saturday', 'sunday']
    
    
    # loop through each community center
    response['results'].each do |rec_center|  
      
      days_of_the_week.each do | day |
        if rec_center[day].present?
          parse_days(rec_center[day], day).each do | event |
            event[:location] = rec_center['rec_center_name']
            event[:until] = rec_center['schedule_until']
            @events.push(event)
          end
        end
      end
    end
 
    
    render :template => 'dropins/import'
  end
  
  private
  def parse_days(events = [], day)
    parsed_events = []
    
    if events.is_a?(String)
      time_capture = /(\d{1,2}:\d{2}[ap]m)–(\d{1,2}:\d{2}[ap]m)/.match(events)
      parsed_events.push(:name => events, :day => day, :start_time => time_capture[1], :end_time => time_capture[2])
    else
      events.each do | event |
        time_capture = /(\d{1,2}:\d{2}[ap]m)–(\d{1,2}:\d{2}[ap]m)/.match(event)
        parsed_events.push(:name => event, :day => day, :start_time => time_capture[1], :end_time => time_capture[2])
      end
    end 
    
    return parsed_events
  end
  
  #  private
  #  def parse_time_from_event(event)
  #    regex_match = /(\d{1,2}:\d{2}[ap]m)–(\d{1,2}:\d{2}[ap]m)/.match(event)
  #    start_time
  #    end_time
  #    
  #  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'index'}
      format.json { render :nothing => true, status => :no_conent }
      format.xml { render :nothing => true, status => :no_conent }
    end
  end

  private
  def dropin_params
    params.require(:dropin).permit(:sport, :skill_level, :price_per_one,
      :spots, :notes, :format)
  end

  private
  def event_params
    params.require(:dropin).permit(:name, :location_id, :organization_id, :comments)
  end

end
