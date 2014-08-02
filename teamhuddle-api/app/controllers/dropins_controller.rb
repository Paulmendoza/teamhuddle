class DropinsController < ApplicationController
  include IceCube

  def index
    @dropins = SportEvent.joins(:event).where( sport_events: { type: "dropin"}).select("*")

    respond_to do |format|
      format.html
      format.json { render json: @dropins, :except => [:event_id] }
      format.xml { render xml: @dropins, except: [:event_id] }
    end
  end
  
  def show
    @dropin = SportEvent.find(params[:id])
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
      @dropin.sport = 'volleyball'
      @dropin.event_id = @event.id
      @dropin.type = 'dropin'
      @dropin.price_per_group = -1
      @dropin.spots_filled = -1
      @dropin.gender = 'n/a'
      
      # get the start date and end date NOTE: adds time as well to startime
      start_date = Time.new(params[:start_date][:year], params[:start_date][:month], params[:start_date][:day], 
                            params[:start_time][:hour], params[:start_time][:minute])
      end_date = Time.new(params[:end_date][:year], params[:end_date][:month], params[:end_date][:day])
      
      # create a new schedule setting the duration NOTE: duration isnt working
      schedule = Schedule.new(start_date, :end_time => start_date.to_date.change(hour: params[:end_time][:hour].to_i, minute: params[:end_time][:minute].to_i)) do |s|
        s.add_recurrence_rule(Rule.weekly.day(:monday).until(end_date))
      end
      
      @dropin.schedule = schedule
      
      if @dropin.save
        # once dropin is saved, generate sport event instances
        instances = @dropin.schedule.all_occurrences
        
        instances.each do |i|
          dropin_instance = SportEventInstance.new
          dropin_instance.sport_event_id = @dropin.id
          dropin_instance.datetime_start = i
          
          #for testing TODO figure out durations
          dropin_instance.datetime_end = i + 3600
          
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

  def destroy
    @sportevent = SportEvent.find(params[:id])
    if Event.find(@sportevent.event_id).destroy
      if Event.find(params[:id]).destroy
        render :nothing => true, status => :no_conent
      end
    end
  end

  private
  def dropin_params
    params.require(:dropin).permit(:sport, :skill_level, :price_per_one,
     :price_per_one, :spots, :notes, :format)
  end

  private
  def event_params
    params.require(:dropin).permit(:name, :location_id, :organization_id, :comments)
  end

end
