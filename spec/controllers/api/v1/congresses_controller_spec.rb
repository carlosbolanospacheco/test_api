require 'rails_helper'

describe Api::V1::CongressesController do

	describe "GET #index" do
		before(:each) do
			4.times { FactoryGirl.create :congress }
			get :index
		end

		it "returns 4 records from the database" do
			congresses_response = json_response
			expect(congresses_response.size).to eq(4)
		end
		it { should respond_with :ok }
	end

	describe "GET #show" do
		before(:each) do
			@congress = FactoryGirl.create :congress
			get :show, id: @congress.id, format: :json
		end

		it "returns the information about a congress on a hash" do
			congress_response = json_response
			expect(congress_response[:name]).to eql @congress.name
		end
		it { should respond_with :found }
	end

	describe "POST #create" do
		context "when is successfully created" do
			before(:each) do
				@user = FactoryGirl.create :user
				@congress_attributes = FactoryGirl.attributes_for :congress
				api_authorization_header @user.api_token
				post :create, { congress: @congress_attributes }, format: :json
			end

			it "renders the json representation for the congress record just created" do
				congress_response = json_response
				expect(congress_response[:name]).to eql @congress_attributes[:name]
			end
			it { should respond_with :created }
		end

		context "when is not created because invalid user" do
			before(:each) do
				@congress_attributes = FactoryGirl.attributes_for :congress
				post :create, { congress: @congress_attributes }, format: :json
			end

			it "renders an errors json" do
				congress_response = json_response
				expect(congress_response).to have_key(:errors)
			end

			it { should respond_with :unauthorized }
		end

		context "when is not created because invalid congress" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@invalid_congress_attributes = { name: "Fail congress" }
				post :create, { congress: @invalid_congress_attributes }, format: :json
			end

			it "renders an errors json" do
				congress_response = json_response
				expect(congress_response).to have_key(:errors)
			end

			it { should respond_with :bad_request }
		end

	end

	describe "PATCH #update" do

		context "when is successfully updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@congress = FactoryGirl.create :congress, user: @user
				patch :update, { id: @congress.id, 
												 congress: { name: "Modified name" } }, format: :json
			end

			it "renders the json representation for the updated user" do
				congress_response = json_response
				expect(congress_response[:name]).to eql "Modified name"
			end

			it { should respond_with :ok }
		end

		context "when is not updated because invalid user" do
			before(:each) do
				@user = FactoryGirl.create :user
				@congress = FactoryGirl.create :congress, user: @user
				patch :update, { id: @congress.id,
												 congress: { name: "Modified name" } }, format: :json
			end

			it "renders an errors json" do
				congress_response = json_response
				expect(congress_response).to have_key(:errors)
			end

			it { should respond_with :unauthorized }
		end

		context "when is not updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@congress = FactoryGirl.create :congress, user: @user
				patch :update, { id: @congress.id,
											   congress: { location: nil } }, format: :json
			end

			it "renders an errors json" do
				congress_response = json_response
				expect(congress_response).to have_key(:errors)
			end

			it { should respond_with :bad_request }
		end
	end

	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.api_token
			@congress = FactoryGirl.create :congress, user: @user
			delete :destroy, { id: @congress.id }, format: :json
		end
		it { should respond_with :ok }
	end

end
