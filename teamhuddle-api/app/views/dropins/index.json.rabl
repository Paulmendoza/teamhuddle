collection @sport_event_instances, :root => :dropins, :object_root => false
attributes :id, :datetime_start, :datetime_end

child :sport_event do
    attributes :id, :type, :sport
end

child :event do
    attributes :name
end

child :location do
    attributes :name, :lat, :long
end




