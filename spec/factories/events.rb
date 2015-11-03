FactoryGirl.define do
	factory :event do
		name { Faker::Name.name }
		location { Faker::Address.city }
		start_date { Faker::Time.between(10.days.ago, 5.days.ago) }
		duration { Faker::Number.number(3) }
		capacity { Faker::Number.number(4) }
		congress
	end
end