class Api::V1::UsersController < Api::V1::GlobalController
	before_filter :authenticate_user!

	def index
		authorize @current_user
		users = User.all
		render json: users, status: :ok
	end

	def create
		authorize @current_user
		user = User.new(create_params)
		return api_error(status: :bad_request, errors: user.errors) unless user.valid?
		if user.save
			render json: user, status: :created
    else
      render nothing: true, status: :unprocessable_entity
    end
	end

	def show
		authorize @current_user
		user = User.find(params[:id])
		render json: user, status: :found
	end

	def update
		authorize @current_user
		user = User.find(params[:id])
		if user.update(update_params)
      render json: user, state: :ok
    else
			return api_error(status: :bad_request, errors: user.errors)
    end
	end

	def destroy
		authorize @current_user
		if User.find(params[:id]).destroy
			users = User.all
			render json: users, status: :ok
		else
			return api_error(status: :bad_request, errors: user.errors)
		end
	end

	private

		def create_params
			params.require(:user).permit(:email, :name, :password, :role)
		end

		def update_params
			params.require(:user).permit(:email, :name, :role)
		end

end