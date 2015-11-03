FactoryGirl.define do
	factory :user do
		email {Faker::Internet.email}
		password "test"
		name {Faker::Name.name}
		role :admin
	end
end