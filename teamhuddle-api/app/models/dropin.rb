class Dropin
  
  
  def self.new(name,
      location_id ,
      organization_id,
      comments = nil,
      sport,
      skill_level,
      price_per_one,
      schedule)
           
    @event = Event.new
    @event.name = name
    @event.location = Location.find(location_id)
    @event.organization = Organization.find(organization_id)
    @event.comments = comments
    
    
    if @event.save
      @dropin = SportEvent.new
      @dropin.sport = sport
      @dropin.price_per_one = price_per_one
      @dropin.skill_level = skill_level
      @dropin.event_id = @event.id
      @dropin.type = 'dropin'
      @dropin.spots_filled = -1
      @dropin.gender = 'n/a'
      
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
            return @dropin
          end
        end
        
      else
        @event.destroy
        return @dropin
      end
    else
      return @event
    end
    
    
  end
end
      