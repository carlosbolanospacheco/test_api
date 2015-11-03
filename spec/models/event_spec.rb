require 'rails_helper'

describe Event do
	let (:event) { FactoryGirl.build(:event) }
	subject { event }
 	it { should respond_to(:name) }
 	it { should respond_to(:location) }
  it { should respond_to(:start_date) }
  it { should respond_to(:duration) }
  it { should respond_to(:capacity) }
	it { should validate_presence_of(:name)}
	it { should validate_presence_of(:location) }
	it { should validate_presence_of(:start_date) }
	it { should validate_presence_of(:duration) }
	it { should validate_presence_of(:capacity) }
	it { should belong_to(:congress) }

end