collection @sport_event_instances
attributes :id, :datetime_start, :datetime_end

child :sport_event do
    attributes :id, :type, :sport
end

child :location do
    attributes :name, :lat, :long
end




