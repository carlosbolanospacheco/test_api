class Api::V1::UsersController < Api::V1::GlobalController
	before_filter :authenticate_user!

	def index
		authorize @current_user
		users = User.all
		render json: users.to_json
	end

	def create
		authorize @current_user
		user = User.new(create_params)
		logger.debug(user.to_json)
		return api_error(status: :bad_request, errors: user.errors) unless user.valid?
		if user.save
			render json: user.to_json, status: :created
    else
      render nothing: true, status: :bad_request
    end
	end

	def show
		authorize @current_user
		user = User.find(params[:id])
		render json: user.to_json, status: :found
	end

	def update
		authorize @current_user
		if user.update(create_params)
      render json: user.to_json, state: :ok
    else
			return api_error(status: :bad_request, errors: user.errors)
    end
	end

	def destroy
		authorize @current_user
		if User.find(params[:id]).destroy
			render nothing: true, status: :ok
		else
			return api_error(status: :bad_request, errors: user.errors)
		end
	end

	private

		def create_params
			params.require(:user).permit(:email, :name, :password, :role)
		end

end