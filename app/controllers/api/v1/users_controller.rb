class Api::V1::UsersController < Api::V1::GlobalController
	before_filter :authenticate_user!

	def index
		authorize @current_user
		users = User.all
		users_data = []
		users.each do |user|
			users_data.push(copyUser(user))
		end
		render json: users_data, status: :ok
	end

	def create
		authorize @current_user
		user = User.new(create_params)
		return api_error(status: :bad_request, errors: user.errors) unless user.valid?
		if user.save
			single_user = copyUser(user)
			render json: single_user, status: :created
    else
      render nothing: true, status: :bad_request
    end
	end

	def show
		authorize @current_user
		user = User.find(params[:id])
		single_user = copyUser(user)
		render json: single_user, status: :found
	end

	def update
		authorize @current_user
		user = User.find(params[:id])
		if user.update(update_params)
			single_user = copyUser(user)
      render json: single_user, state: :ok
    else
			return api_error(status: :bad_request, errors: user.errors)
    end
	end

	def destroy
		authorize @current_user
		if User.find(params[:id]).destroy
			users = User.all
			users_data = []
			users.each do |user|
				users_data.push(copyUser(user))
			end
			render json: users_data, status: :ok
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

		def copyUser(user)
			single_user = {}
			single_user[:id] = user[:id]
			single_user[:name] = user[:name]
			single_user[:email] = user[:email]
			single_user[:role] = user.role
			return single_user
		end

end