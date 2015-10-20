class Congress < ActiveRecord::Base
	belongs_to :user
	has_many :events, dependent: :destroy
	validates :name, :location, :start_date, :end_date, :user_id, presence: true

end