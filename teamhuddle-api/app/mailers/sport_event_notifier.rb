class SportEventNotifier < ActionMailer::Base
  default from: "noreply@teamhudde.ca"
  layout 'base_email'

  def sport_events_expiring_soon
    @sport_events = SportEvent
                        .where('dt_expiry > ? AND dt_expiry < ?', Date.today - 1.weeks, Date.today + 2.weeks)
                        .order(dt_expiry: :asc)

    mail to: Rails.env.production? ? "contact@teamhuddle.ca" : "akos_sebestyen@hotmail.com",
         cc: "akos_sebestyen@hotmail.com",
         subject: "#{@sport_events.count} Dropins Expiring Soon"
  end

end
