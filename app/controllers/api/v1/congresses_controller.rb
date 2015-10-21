class Api::V1::CongressesController < Api::V1::GlobalController
	before_filter :authenticate_user!, only: [:create, :update, :destroy]

	def index
		congresses = Congress.all
		checkUser?
		congresses_data = []
		congresses.each do |congress|
			congresses_data.push(copyCongress(congress))
		end
		render json: congresses_data, status: :ok
	end

	def show
		congress = Congress.find(params[:id])
		single_congress = copyCongress(congress)
		checkUser?
		render json: single_congress, status: :found
	end

	def create
		congress = Congress.new(create_params)
		congress.user = @current_user
		return api_error(status: :bad_request, errors: congress.errors) unless congress.valid?
		if congress.save
			single_congress = copyCongress(congress)
			render json: single_congress, status: :created
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
			single_congress = copyCongress(congress)
      render json: single_congress, state: :ok
    else
			return api_error(status: :bad_request, errors: congress.errors)
    end
	end

	def destroy
		congress = Congress.find(params[:id])
		authorize congress
		if congress.destroy
			congresses = Congress.all
			checkUser?
			congresses_data = []
			congresses.each do |congress|
				congresses_data.push(copyCongress(congress))
			end
			render json: congresses_data, status: :ok
		else
			return api_error(status: :bad_request, errors: congress.errors)
		end
	end

	private
		def create_params
			params.require(:congress).permit(:name, :location, :start_date, :end_date)
		end

		def copyCongress(congress)
			single_congress = {}
			single_congress[:id] = congress[:id]
			single_congress[:name] = congress[:name]
			single_congress[:location] = congress[:location]
			single_congress[:start_date] = congress[:start_date]
			single_congress[:end_date] = congress[:end_date]
			if @current_user && (@current_user.admin? || congress.user_id == @current_user.id)
				single_congress[:editable] = true
			else
				single_congress[:editable] = false
			end
			return single_congress
		end
end