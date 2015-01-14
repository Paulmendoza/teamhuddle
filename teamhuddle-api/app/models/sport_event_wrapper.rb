class SportEventWrapper  
  
  def self.new(name,
      location_id ,
      organization_id,
      comments,
      sport_event,
      type,
      suppress_sport_event_instances,
      admin_id)
    
    @current_dropin = {}
    
    @current_dropin[:event] = Event.new
    @current_dropin[:event].name = name
    @current_dropin[:event].location_id = location_id
    @current_dropin[:event].organization_id = organization_id
    @current_dropin[:event].comments = comments
    
    if @current_dropin[:event].save
      @current_dropin[:sport_event] = sport_event
      @current_dropin[:sport_event].event_id = @current_dropin[:event].id
      @current_dropin[:sport_event].type = type
      @current_dropin[:sport_event].spots_filled = -1
      @current_dropin[:sport_event].gender = 'n/a'
      @current_dropin[:sport_event].admin_id = admin_id
      
      if @current_dropin[:sport_event].save
        # once dropin is saved, generate sport event instances

        
        sport_event_instances = Array.new
        
        @current_dropin[:sport_event].schedule.each_occurrence do |i|
          dropin_instance = SportEventInstance.new
          dropin_instance.sport_event_id = @current_dropin[:sport_event].id
          dropin_instance.datetime_start = i.start_time.getlocal
          dropin_instance.datetime_end = i.end_time.getlocal
          dropin_instance.event_id = @current_dropin[:event].id
          
          unless dropin_instance.save
            @current_dropin[:errors] = dropin_instance.errors
            dropin_instance.destroy
            @current_dropin[:sport_event].really_destroy!
            @current_dropin[:event].destroy
            return @current_dropin
          end
          
          sport_event_instances.push(dropin_instance)
        end

        # only add it if you really want it
        if not suppress_sport_event_instances
          @current_dropin[:sport_event_instances] = sport_event_instances
        end
        
        
      else
        @current_dropin[:errors] = @current_dropin[:sport_event].errors
        @current_dropin[:event].destroy
        return @current_dropin
      end
    else
      @current_dropin[:errors] = @current_dropin[:event].errors
      @current_dropin[:event].destroy
      return @current_dropin
    end
    
    @current_dropin[:errors] = nil
    # no errors... I don't like this the way this works
    return @current_dropin
    
  end
end
      