require 'rails_helper'

describe Congress do
	before { @congress = FactoryGirl.build(:congress) }
	subject { @congress }
 	it { should respond_to(:name) }
 	it { should respond_to(:location) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }
	it { should validate_presence_of(:name)}
	it { should validate_presence_of(:location) }
	it { should validate_presence_of(:start_date) }
	it { should validate_presence_of(:end_date) }
	it { should belong_to(:user) }
	it { should have_many(:events) }

	describe "#events association" do
		before do
			@congress.save
			3.times { FactoryGirl.create :event, congress: @congress }
		end

		it "destroys the associated events on self destruct" do
			events = @congress.events
			@congress.destroy
			events.each do |event|
				expect(Event.find(event)).to raise_error ActiveRecord::RecordNotFound
			end
		end
	end

end