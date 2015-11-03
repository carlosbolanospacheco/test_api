FactoryGirl.define do
	factory :congress do
		name { Faker::Name.name }
		location { Faker::Address.city }
		start_date { Faker::Time.between(10.days.ago, 5.days.ago) }
		end_date { Faker::Time.between(5.days.ago, Time.now) }
		user
	end
end