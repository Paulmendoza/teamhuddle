collection @sport_event_instances, :root => :dropins, :object_root => false
attributes :id, :datetime_start, :datetime_end

child :sport_event do
    attributes :id, :type, :sport_id, :skill_level, :price_per_one, :spots
end

child :event do
    attributes :name
end

child :location do
    attributes :name, :lat, :long, :address
end

child :organization do
    attributes :name, :phone, :email
end