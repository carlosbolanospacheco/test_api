class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :start_date, :duration
#  belongs_to :congress
end
