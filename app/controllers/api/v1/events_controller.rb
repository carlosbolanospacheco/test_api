class Api::V1::EventsController < Api::V1::GlobalController
	before_filter :authenticate_user!, only: [:create, :update, :destroy]

	def index
		events = Event.where(congress_id: get_event_params[:congress_id])
		logger.debug events
		render json: events.to_json, status: :ok
	end

	def show
		event = Event.find(params[:id])
		render json: event, status: :found
	end

	def create
		congress = Congress.find(create_params[:congress_id])
		authorize congress
		event = Event.new(create_params)
		return api_error(status: :bad_request, errors: event.errors) unless event.valid?
		if event.save
			render json: event.to_json, status: :created
    else
      render nothing: true, status: :bad_request
    end
	end

	def update
		event = Event.find(params[:id])
		return api_error(status: :not_found, errors: "Event not found") unless event.valid?
		authorize event.congress
		if event.update(create_params)
      render json: event, state: :ok
    else
			return api_error(status: :bad_request, errors: event.errors)
    end
	end

	def destroy
		event = Event.find(params[:id])
		authorize event.congress
		if event.destroy
			render nothing: true, status: :ok
		else
			return api_error(status: :bad_request, errors: event.errors)
		end
	end

	private
		def create_params
			params.require(:event).permit(:name, :location, :start_date, :duration, :capacity, :congress_id)
		end

		def get_event_params
			params.permit(:congress_id)
		end

end