class SportEventNotifier < ActionMailer::Base
  default from: "noreply@teamhudde.ca"
  layout 'base_email'

  def sport_events_expiring_soon
    @sport_events = SportEvent.find_by_sql(['SELECT se.* FROM events AS e
                                            JOIN sport_events AS se ON se.id = (SELECT id
                                                                                FROM sport_events
                                                                                WHERE sport_events.event_id = e.id
                                                                                ORDER BY dt_expiry DESC
                                                                                LIMIT 1)
                                            WHERE se.dt_expiry > ? AND se.dt_expiry < ?
                                            ORDER BY dt_expiry ASC', Date.today - 1.weeks, Date.today + 2.weeks])

    mail to: Rails.env.production? ? "eje.marc.daniel@gmail.com" : "akos_sebestyen@hotmail.com",
         cc: "akos_sebestyen@hotmail.com",
         subject: "#{@sport_events.count} Dropins Expiring Soon"
  end

end
