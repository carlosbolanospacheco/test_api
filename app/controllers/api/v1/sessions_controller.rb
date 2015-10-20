class Api::V1::SessionsController < Api::V1::GlobalController
	def create
    user = User.find_by(email: create_params[:email])
    password = Digest::SHA1.base64digest(create_params[:password])
    if user && user[:password] == password
      is_admin = false
      is_admin = true if user.admin?
      head :created, token: user[:api_token], name: user[:name], is_admin: is_admin, id: user[:id]
    else
      return api_error(status: :unauthorized, errors: {'error'=>'Unauthorized'})
    end
	end

	private
		def create_params
		  params.require(:session).permit(:email, :password)
		end
end