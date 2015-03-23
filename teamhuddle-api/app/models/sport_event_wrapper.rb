class SportEventWrapper

  def self.new(name,
      location_id,
      organization_id,
      comments,
      sport_event,
      type,
      admin_id)

    @current_dropin = {}

    @current_dropin[:event] = Event.new
    @current_dropin[:event].name = name
    @current_dropin[:event].location_id = location_id
    @current_dropin[:event].organization_id = organization_id
    @current_dropin[:event].comments = comments

    if @current_dropin[:event].save
      @current_dropin = link_to_event(@current_dropin, sport_event, type, admin_id)
    else
      @current_dropin[:errors] = @current_dropin[:event].errors
      @current_dropin[:event].destroy
      return @current_dropin
    end

    # no errors... I don't like this the way this works
    return @current_dropin
  end

  def self.renew(event, sport_event, type, admin_id)
    @current_dropin = {}

    @current_dropin[:event] = event

    @current_dropin = link_to_event(@current_dropin, sport_event, type, admin_id, is_renewal: true)

    # no errors... I don't like this the way this works
    return @current_dropin
  end

  private
  def self.link_to_event(current_dropin, sport_event, type, admin_id, options = {})

    is_renewal = false
    is_renewal = options[:is_renewal] if options[:is_renewal].present?

    suppress_sport_event_instances = false
    suppress_sport_event_instances = options[:suppress_sport_event_instances] if options[:suppress_sport_event_instances].present?

    current_dropin[:sport_event] = sport_event
    current_dropin[:sport_event].event_id = current_dropin[:event].id
    current_dropin[:sport_event].type = type
    current_dropin[:sport_event].spots_filled = -1
    current_dropin[:sport_event].gender = 'n/a'
    current_dropin[:sport_event].admin_id = admin_id
    current_dropin[:sport_event].dt_expiry = current_dropin[:sport_event].schedule.last

    if current_dropin[:sport_event].save
      # once dropin is saved, generate sport event instances

      sport_event_instances = Array.new

      current_dropin[:sport_event].schedule.each_occurrence do |i|
        dropin_instance = SportEventInstance.new
        dropin_instance.sport_event_id = current_dropin[:sport_event].id
        dropin_instance.datetime_start = i.start_time.getlocal
        dropin_instance.datetime_end = i.end_time.getlocal
        dropin_instance.event_id = current_dropin[:event].id

        unless dropin_instance.save
          current_dropin[:errors] = dropin_instance.errors

          dropin_instance.destroy
          current_dropin[:sport_event].really_destroy!

          unless is_renewal
            current_dropin[:event].destroy
          end

          return current_dropin
        end

        sport_event_instances.push(dropin_instance)
      end

      # only add it if you really want it
      if not suppress_sport_event_instances
        current_dropin[:sport_event_instances] = sport_event_instances
      end

    else
      current_dropin[:errors] = current_dropin[:sport_event].errors

      unless is_renewal
        current_dropin[:event].destroy
      end

    end
    return current_dropin
  end
end
      