class Api::V1::CongressesController < Api::V1::GlobalController
	before_filter :authenticate_user!, only: [:create, :update, :destroy]

	def index
		congresses = Congress.all
		render json: congresses.to_json
	end

	def show
		congress = Congress.find(params[:id])
		render json: congress, status: :found
	end

	def create
		congress = Congress.new(create_params)
		congress.user = @current_user
		return api_error(status: :bad_request, errors: congress.errors) unless congress.valid?
		if congress.save
			render json: congress, status: :created
    else
      return api_error(status: :bad_request, errors: congress.errors)
    end
	end

	def update
		congress = Congress.find(params[:id])
		authorize congress
		logger.debug('after')
		return api_error(status: :not_found, errors: "Congress not found") unless congress.valid?
		if congress.update(create_params)
      render json: congress, state: :ok
    else
			return api_error(status: :bad_request, errors: congress.errors)
    end
	end

	def destroy
		congress = Congress.find(params[:id])
		authorize congress
		if congress.destroy
			render nothing: true, status: :ok
		else
			return api_error(status: :bad_request, errors: congress.errors)
		end
	end

	private
		def create_params
			params.require(:congress).permit(:name, :location, :start_date, :end_date)
		end

end