
class LocationSerializer < ActiveModel::Serializer
  attributes :id, :address, :lat, :long, :name
end

