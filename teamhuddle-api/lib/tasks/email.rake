namespace :email do
  namespace :notify_admin do
    desc 'Sends email to admin about expiring dropins'

    task :expiring_dropins => :environment do
      SportEventNotifier.sport_events_expiring_soon.deliver
    end
  end
end