class DropinsController < ApplicationController
  include IceCube

  before_action :authenticate_admin!

  def index
    #default to volleyball right now
    @sport_param = "volleyball"
    @sport_param = params[:sport] if params[:sport].present?

    @show_all = params[:show_all] == "true"

    @conditions = {:type => "dropin", :sport_id => @sport_param, :deleted_at => nil}
    @conditions[:is_active] = true unless @show_all

    # This is for the admin page -> see index.erb
    @dropins_grid = initialize_grid(SportEvent,
      :include => [:event, :location, :organization],
      :conditions => @conditions,
      :enable_export_to_csv => true,
      :csv_field_separator => ';',
      :csv_file_name => 'dropins',
      :name => 'dropins'
    )

    export_grid_if_requested('dropins' => 'dropins_grid') do
      # usual render or redirect code executed if the request is not a CSV export request
    end
  end
  
  def show
    @dropin = SportEvent.includes(:event, :location, :organization).find(params[:id])

    begin
      @created_by_admin = Admin.find(@dropin.admin_id)
    rescue ActiveRecord::RecordNotFound
      # wut
    end

  end

  def create

    # get the start date and end date NOTE: adds time as well to startime
    start_date = Time.new(params[:start_date][:year], params[:start_date][:month], params[:start_date][:day], 
      params[:start_time][:hour], params[:start_time][:minute])
    end_date = Time.new(params[:end_date][:year], params[:end_date][:month], params[:end_date][:day])
      
    # create a new schedule setting the duration
    schedule = Schedule.new(start_date, :end_time => start_date.change(hour: params[:end_time][:hour], min: params[:end_time][:minute])) do |s|
      # add weekly recurrence ruling based on the day of the week selected
      s.add_recurrence_rule(Rule.weekly.day(params[:day].intern).until(end_date))
    end
    
    temp_event = SportEvent.new(dropin_params)
    temp_event.sport_id = params[:sport_event][:sport]
    temp_event.skill_level = params[:skill_level]
    temp_event.schedule = schedule
    
    @dropin = SportEventWrapper.new(params[:sport_event][:name],
      params[:sport_event][:location],
      params[:sport_event][:organization],
      params[:sport_event][:comments],
      temp_event,
      'dropin',
      false,
      current_admin.id
    )
    
    if @dropin[:errors].present?
      render json: { error: @dropin[:errors] }, :status => :unprocessable_entity
    else
      respond_to do |format|
        format.json { render json: @dropin }
        format.html { redirect_to dropin_path(@dropin[:sport_event]) }
      end
    end
  end
  
  def destroy
    SportEvent.find(params[:id]).destroy
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
    @dropin = SportEvent.includes(:event).find(params[:id])
  end

  def update
    @dropin = SportEvent.find(params[:id])
    @event = Event.find(@dropin.event_id)

    @event.attributes = {
        :name => params[:sport_event][:name],
        :location_id => params[:sport_event][:location],
        :organization_id => params[:sport_event][:organization],
        :comments => params[:sport_event][:comments]
    }

    @dropin.attributes = dropin_params

    @dropin.attributes = {
        :sport_id => params[:sport_event][:sport],
        :skill_level => params[:skill_level]
    }

    if @event.valid? && @dropin.valid?
      @event.save
      @dropin.save
      redirect_to dropin_path(@dropin)
    else
      render json: { error: @event.errors }, :status => :unprocessable_entity
    end
  end

  def renew
    @dropin = SportEvent.includes(:event).find(params[:id])
  end

  def duplicate
    # get the start date and end date NOTE: adds time as well to startime
    start_date = Time.new(params[:start_date][:year], params[:start_date][:month], params[:start_date][:day],
                          params[:start_time][:hour], params[:start_time][:minute])
    end_date = Time.new(params[:end_date][:year], params[:end_date][:month], params[:end_date][:day])

    # create a new schedule setting the duration
    schedule = Schedule.new(start_date, :end_time => start_date.change(hour: params[:end_time][:hour], min: params[:end_time][:minute])) do |s|
      # add weekly recurrence ruling based on the day of the week selected
      s.add_recurrence_rule(Rule.weekly.day(params[:day].intern).until(end_date))
    end

    temp_event = SportEvent.new(dropin_params)
    temp_event.sport_id = params[:sport_event][:sport]
    temp_event.skill_level = params[:skill_level]
    temp_event.schedule = schedule

    @dropin = SportEventWrapper.new(params[:sport_event][:name],
                                    params[:sport_event][:location],
                                    params[:sport_event][:organization],
                                    params[:sport_event][:comments],
                                    temp_event,
                                    'dropin',
                                    false,
                                    current_admin.id
    )

    if @dropin[:errors].present?
      render json: { error: @dropin[:errors] }, :status => :unprocessable_entity
    else
      respond_to do |format|
        format.json { render json: @dropin }
        format.html { redirect_to dropin_path(@dropin[:sport_event]) }
      end
    end
  end

  def import
  end
  
  def scrape
    # get a response from the API
    response = RestClient.get params[:api_url]
    
    # turn the JSON response into a hash
    response = JSON.parse(response)
    
    @events = []
    
    days_of_the_week = %w(monday tuesday wednesday thursday friday saturday sunday)

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
    
    # go through all parse events and try and create dropins from them
    
    @tentative_events = Array.new
    
    @events.each do |event|
      temp_dropin = create_dropin_from_scrape_object(event)
      
      @tentative_events.push(temp_dropin)
      
      
    end
    respond_to do |format|
      format.html { render json: @tentative_events }
      format.json { render json: @tentative_events }
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
    # hardcoded right now. TODO change this
    start_datetime = Time.new(2014, 6, 31, start_time.hour, start_time.min) 
    end_date = Time.new(2014, 12, 31)
      
    # create a new schedule setting the duration
    schedule = Schedule.new(start_datetime, :end_time => start_datetime.change(hour: end_time.hour, min: end_time.min)) do |s|
      # add weekly recurrence ruling based on the day of the week selected
      s.add_recurrence_rule(Rule.weekly.day(days_of_the_week[event[:day]]).until(end_date))
    end
    
    # dropin = SportEventWrapper.new((0..16).to_a.map{|a| rand(16).to_s(16)}.join, #random name for now
    #   9, # harcode everything to Creekside. TODO: change this to dynamic lookup
    #   5, # hardcoded to Vancouver board right now. TODO: change to dynamic lookup
    #   nil,
    #   'volleyball', # hardcoded to volleyball. TODO: change to dynamic lookup
    #   'Beginner', # hardcoded to random value TODO: try and parse this with regexes
    #   0,
    #   schedule,
    #   true)
    
    return dropin
    
  end

  private
  def dropin_params
    params.require(:sport_event).permit(:skill_level, :price_per_one, :price_per_group,
      :spots, :notes, :format, :source)
  end

  private
  def event_params
    params.require(:sport_event).permit(:name, :location, :organization, :comments)
  end

end
