# Preview all emails at http://localhost:3000/rails/mailers/sport_event_notifier
class SportEventNotifierPreview < ActionMailer::Preview


  def sport_events_expiring_soon

    SportEventNotifier.sport_events_expiring_soon
  end
end
