namespace :email do
  namespace :notify_admin do
    desc 'Sends email to admin about expiring dropins'

    task :expiring_dropins => :environment do
      puts 'Sending email...'
      SportEventNotifier.sport_events_expiring_soon.deliver
      puts 'Email sent!'
    end
  end
end