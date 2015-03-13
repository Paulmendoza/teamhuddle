# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/home/deploy/teamhuddle-web/teamhuddle-api/log/cron_log.log"

every :daily, at: "2:30 am" do
  # command "/usr/bin/some_great_command"
  runner "SportEvent.update_inactive_dropins"
  # rake "some:great:rake:task"
end

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "SportEvent.update_inactive_dropins"
#   rake "some:great:rake:task"
# end

#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
