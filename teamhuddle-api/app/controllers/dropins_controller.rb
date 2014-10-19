class DropinsController < ApplicationController
  include IceCube

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
    
    
    # This is for the API -> see index.json.rabl
    @sport_event_instances = SportEventInstance.includes(:event, :location, :sport_event)
                                               .between(from, to)
                                               .where( sport_events: { type: "dropin", sport: @sport})
    
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
    @event = Event.new(event_params)
    
    if @event.save
      @dropin = SportEvent.new
      @dropin.sport = params[:dropin][:sport]
      @dropin.price_per_one = params[:dropin][:price_per_one]
      @dropin.skill_level = params[:skill_level]
      @dropin.event_id = @event.id
      @dropin.type = 'dropin'
      @dropin.spots_filled = -1
      @dropin.gender = 'n/a'
      
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
      
      @dropin.schedule = schedule
      
      if @dropin.save
        # once dropin is saved, generate sport event instances
        duration = @dropin.schedule.end_time - @dropin.schedule.start_time
        
        @dropin.schedule.each_occurrence do |i|
          dropin_instance = SportEventInstance.new
          dropin_instance.sport_event_id = @dropin.id
          dropin_instance.datetime_start = i
          dropin_instance.datetime_end = i + duration
          dropin_instance.event_id = @event.id
          
          unless dropin_instance.save
            @dropin.destroy
            render json: { error: @dropin.errors }, :status => :unprocessable_entity
          end
        end
        
        
        respond_to do |format|
          format.json { render json: @dropin }
          format.html { redirect_to action: 'index' }
        end
      else
        @event.destroy
        render json: { error: @dropin.errors }, :status => :unprocessable_entity
      end
    else
      render json: { error: @event.errors }, :status => :unprocessable_entity
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
    
    events = []
    
    
    
#    # loop through each community center
#    response['results'].each do |rec_center|  
#      
#      parse_days(rec_center['monday']).each do | event |
#        events.push(event)
#      end
#    end
    
    render json: response['results'] , :status => :ok
  end
  
#  private
#  def parse_days(events)
#    parsed_events = []
#    
#    events.each do | event |
#      event
#    end
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
