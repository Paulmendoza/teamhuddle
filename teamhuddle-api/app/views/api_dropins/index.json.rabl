collection @sport_event_instances, :root => :dropins, :object_root => false
attributes :id

# custom datetime nodes to get around wonky TZinfo serialization
node :datetime_start do |sei|
  sei.datetime_start.utc
end

node :datetime_end do |sei|
  sei.datetime_end.utc
end

child :sport_event do
  attributes :id, :type, :sport_id, :skill_level, :price_per_one, :spots, :source
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