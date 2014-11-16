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
    @dropins = SportEvent.includes(:event, :location, :organization)
    .where( sport_events: { type: "dropin", sport_id: @sport, dtDeleted: nil })
    .order(:created_at)
    
    
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
  
  def destroy
    SportEvent.find(params[:id]).soft_delete
    respond_to do |format|
      format.html { redirect_to :action => 'index'}
      format.json { render :nothing => true, status => :no_conent }
      format.xml { render :nothing => true, status => :no_conent }
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
      
      # see if there is anything per day
      days_of_the_week.each do | day |
        
        if rec_center[day].present?
          
          # sometimes it's just a single event otherwise an array
          if rec_center[day].is_a?(String)
            @events.push(parse_event(rec_center[day], day, rec_center['rec_center_name'], rec_center['schedule_until']))
          else
            rec_center[day].each do | event |
              @events.push(parse_event(event, day, rec_center['rec_center_name'], rec_center['schedule_until']))
            end
          end
          
        end
      end
    end
    
    @events.each do |event|
      
      error = create_dropin_from_scrape_object(event)
      unless error.nil?
        event[:error] = error  
      end
      
      render :template => 'dropins/import'
    end
  end
  
  private
  def parse_event(event, day, location, schedule_until)
    
    @parsed_event = {}
    
    time_capture = /(\d{1,2}:\d{2}[ap]m)–(\d{1,2}:\d{2}[ap]m)/.match(event)
    
    @parsed_event[:name] = event
    @parsed_event[:day] = day
    @parsed_event[:start_time] = time_capture[1]
    @parsed_event[:end_time] = time_capture[2]
    @parsed_event[:location] = location
    @parsed_event[:until] = schedule_until
    
    return @parsed_event
  end
  
  private
  def create_dropin_from_scrape_object(event)
    days_of_the_week = {
      'monday' => :monday,
      'tuesday' => :tuesday,
      'wednesday' => :wednesday,
      'thursday' => :thursday,
      'friday' => :friday,
      'saturday' => :saturday,
      'sunday' => :sunday
    }
    
    start_time = Time.parse(event[:start_time])
    end_time = Time.parse(event[:end_time])
    
    # get the start date and end date NOTE: adds time as well to startime
    start_datetime = Time.new(2014, 6, 31, start_time.hour, start_time.min) 
    end_date = Time.new(2014, 12, 31)
      
    # create a new schedule setting the duration
    schedule = Schedule.new(start_datetime, :end_time => start_datetime.change(hour: end_time.hour, min: end_time.min)) do |s|
      # add weekly recurrence ruling based on the day of the week selected
      s.add_recurrence_rule(Rule.weekly.day(days_of_the_week[event[:day]]).until(end_date))
    end
    
    dropin = Dropin.new((0..16).to_a.map{|a| rand(16).to_s(16)}.join, #random name for now
      9, # harcode everything to Creekside. TODO: change this to dynamic lookup
      5, # hardcoded to Vancouver board right now. TODO: change to dynamic lookup
      nil,
      'volleyball', # hardcoded to volleyball. TODO: change to dynamic lookup
      0,
      'Beginner', # hardcoded to random value TODO: try and parse this with regexes
      schedule)
    
    #    # if there are errors, return them
    #    if dropin.errors.count > 0
    #      return dropin.errors
    #    end
    
    # otherwise return nil
    return nil
    
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
