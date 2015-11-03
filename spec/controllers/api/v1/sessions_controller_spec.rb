require 'rails_helper'

describe Api::V1::SessionsController do

	describe "POST #create" do

		before(:each) do
			@user = FactoryGirl.create :user
			@user.save
		end

		context "when the credentials are correct" do
			before(:each) do
				credentials = { email: @user.email, password: "test" }
				post :create, credentials
			end

			it "returns the user record corresponding to the given credentials" do	
				expect(response.headers[:token].eql?@user.api_token)
			end

			it { should respond_with :created }
		end

		context "when the credentials are incorrect" do
			before(:each) do
				credentials = { email: @user.email, password: "invalidpassword" }
				post :create, { session: credentials }
			end

			it "returns a json with an error" do
				expect(JSON.parse(response.body)["errors"].eql?"Unauthorized")
			end

			it { should respond_with :unauthorized }
		end
	end
end
