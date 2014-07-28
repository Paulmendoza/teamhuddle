class DropinsController < ApplicationController

  def index
    @dropins = SportEvent.joins(:event).where( sport_events: { type: "dropin"}).select("*")

    respond_to do |format|
      format.html
      format.json { render json: @dropins, :except => [:event_id] }
      format.xml { render xml: @dropins, except: [:event_id] }
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
      
      if @dropin.save
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
    params.require(:dropin).permit(:name, :location_id, :organization_id)
  end

end
