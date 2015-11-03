require 'rails_helper'

describe Api::V1::EventsController do

	describe "GET #index" do
		before(:each) do
			@user = FactoryGirl.create :user
			@congress = FactoryGirl.create :congress, user: @user
			4.times { FactoryGirl.create :event, congress: @congress }
			get :index, { congress_id: @congress.id }
		end

		it "returns 4 records from the database" do
			events_response = json_response
			expect(events_response.size).to eq(4)
		end
		it { should respond_with :ok }
	end

	describe "GET #show" do
		before(:each) do
			@event = FactoryGirl.create :event
			get :show, id: @event.id, format: :json
		end

		it "returns the information about a event on a hash" do
			event_response = json_response
			expect(event_response[:name]).to eql @event.name
		end
		it { should respond_with :found }
	end

	describe "POST #create" do
		context "when is successfully created" do
			before(:each) do
				@user = FactoryGirl.create :user
				@congress = FactoryGirl.create :congress, user: @user
				@event_attributes = FactoryGirl.attributes_for :event, congress: @congress
				@event_attributes[:congress_id] = @congress.id
				api_authorization_header @user.api_token
				post :create, { event: @event_attributes }, format: :json
			end

			it "renders the json representation for the event record just created" do
				event_response = json_response
				expect(event_response[:name]).to eql @event_attributes[:name]
			end
			it { should respond_with :created }
		end

		context "when is not created because invalid user" do
			before(:each) do
				@event_attributes = FactoryGirl.attributes_for :event
				post :create, { event: @event_attributes }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
			end

			it { should respond_with :unauthorized }
		end

		context "when is not created because invalid congress" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@invalid_event_attributes = { name: "Fail event" }
				post :create, { event: @invalid_event_attributes }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
			end

			it { should respond_with :not_found }
		end

		context "when is not created because invalid event" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@congress = FactoryGirl.create :congress, user: @user
				@invalid_event_attributes = { name: "Fail event", congress_id: @congress.id }
				post :create, { event: @invalid_event_attributes }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
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
				@event = FactoryGirl.create :event, congress: @congress
				patch :update, { id: @event.id, 
												 event: { name: "Modified name" } }, format: :json
			end

			it "renders the json representation for the updated user" do
				event_response = json_response
				expect(event_response[:name]).to eql "Modified name"
			end

			it { should respond_with :ok }
		end

		context "when is not updated because invalid user" do
			before(:each) do
				@user = FactoryGirl.create :user
				@congress = FactoryGirl.create :congress, user: @user
				@event = FactoryGirl.create :event, congress: @congress
				patch :update, { id: @event.id,
												 event: { name: "Modified name" } }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
			end

			it { should respond_with :unauthorized }
		end

		context "when is not updated" do
			before(:each) do
				@user = FactoryGirl.create :user
				@congress = FactoryGirl.create :congress, user: @user
				@event = FactoryGirl.create :event, congress: @congress
				api_authorization_header @user.api_token
				patch :update, { id: @event.id,
											   event: { location: nil } }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
			end

			it { should respond_with :bad_request }
		end
	end

	describe "DELETE #destroy" do

		context "when is successfully deleted" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@congress = FactoryGirl.create :congress, user: @user
				@event = FactoryGirl.create :event, congress: @congress
				delete :destroy, { id: @event.id }, format: :json
			end
			it { should respond_with :ok }
		end

		context "when is not deleted because invalid user" do
			before(:each) do
				@user = FactoryGirl.create :user
				@congress = FactoryGirl.create :congress, user: @user
				@event = FactoryGirl.create :event, congress: @congress
				delete :destroy, { id: @event.id }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
			end

			it { should respond_with :unauthorized }
		end

		context "when is not deleted" do
			before(:each) do
				@user = FactoryGirl.create :user
				api_authorization_header @user.api_token
				@congress = FactoryGirl.create :congress, user: @user
				@event = FactoryGirl.create :event, congress: @congress
				delete :destroy, { id: @event.id + 1 }, format: :json
			end

			it "renders an errors json" do
				event_response = json_response
				expect(event_response).to have_key(:errors)
			end

			it { should respond_with :not_found }
		end

	end

end
