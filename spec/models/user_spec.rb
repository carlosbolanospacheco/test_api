require 'rails_helper'

describe User do
	before { @user = FactoryGirl.build(:user) }
	subject { @user }
 	it { should respond_to(:name) }
 	it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:role) }
  it { should respond_to(:api_token) }
	it { should be_valid }
	it { should validate_presence_of(:email)}
	it { should validate_uniqueness_of(:email) }
	it { should allow_value('example@test.com').for(:email)}
	it { should validate_presence_of(:name) }
	it { should validate_length_of(:name) }
	it { should validate_presence_of(:password) }
	it { should validate_presence_of(:role) }
	it { should validate_uniqueness_of(:api_token) }
	it { should have_many(:congresses) }

	describe "#generate_api_token" do
		it "generates a unique token" do
			@user.api_token = "auniquetoken123"
			expect(@user.api_token).to eql "auniquetoken123"
		end

		it "generates another token when one already has been taken" do
			existing_user = FactoryGirl.create(:user, api_token: "auniquetoken123")
			@user.generate_api_token
			expect(@user.api_token).not_to eql existing_user.api_token
		end

	end

	describe "#congresses association" do
		before do
			@user.save
			3.times { FactoryGirl.create :congress, user: @user }
		end

		it "destroys the associated congresses on self destruct" do
			congresses = @user.congresses
			@user.destroy
			congresses.each do |congress|
				expect(Congress.find(congress)).to raise_error ActiveRecord::RecordNotFound
			end
		end
	end

end