require 'rails_helper'

describe Api::V1::UsersController do
	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.api_token
			get :show, id: @user.id, format: :json
		end

		it "returns the information about a user on a hash" do
			user_response = json_response
			expect(user_response[:email]).to eql @user.email
		end
		it { should respond_with :found }
	end

	describe "POST #create" do

		context "when is successfully created" do
			before(:each) do
				@user = FactoryGirl.create :user
				@user_attributes = FactoryGirl.attributes_for :user
				api_authorization_header @user.api_token
				post :create, { user: @user_attributes }, format: :json
			end

			it "renders the json representation for the user record just created" do
				user_response = json_response
				expect(user_response[:email]).to eql @user_attributes[:email]
			end
			it { should respond_with :created }
		end

		context "when is not created" do
			before(:each) do
				@invalid_user_attributes = { password: "12345678" }
				post :create, { user: @invalid_user_attributes }, format: :json
			end

			it "renders an errors json" do
				user_response = json_response
				expect(user_response).to have_key(:errors)
			end

			it { should respond_with :unauthorized }
		end
	end

	describe "PATCH #update" do

		context "when is successfully updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				patch :update, { id: @user.id,
				user: { email: "newmail@example.com" } }, format: :json
			end

			it "renders the json representation for the updated user" do
				user_response = json_response
				expect(user_response[:email]).to eql "newmail@example.com"
			end

			it { should respond_with :ok }
		end

		context "when is not updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				patch :update, { id: @user.id,
				user: { email: "bademail.com" } }, format: :json
			end

			it "renders an errors json" do
				user_response = json_response
				expect(user_response).to have_key(:errors)
			end

			it { should respond_with :bad_request }
		end
	end

	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.api_token
			delete :destroy, { id: @user.id }, format: :json
		end
		it { should respond_with :ok }
	end

end
