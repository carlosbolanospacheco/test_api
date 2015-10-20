class Event < ActiveRecord::Base
	belongs_to :congress
	validates :name, :location, :start_date, :duration, :capacity, :congress_id, presence: true
end