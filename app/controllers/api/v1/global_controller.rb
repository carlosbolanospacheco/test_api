class Api::V1::GlobalController < ApplicationController
	include Pundit
	protect_from_forgery with: :null_session
	before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!
	rescue_from Pundit::NotAuthorizedError, with: :unauthorized!

  attr_accessor :current_user

  protected
  	def destroy_session
  		request.session_options[:skip] = true
  	end

  	def not_found!
  		return api_error(status: :not_found, errors: {:error=>'Not found'})
  	end

  	def api_error(status: :bad_request, errors: [])
    	unless Rails.env.production?
      	puts errors.full_messages if errors.respond_to? :full_messages
    	end
    	#head status and return if errors.empty?
    	render json: {error: 'Bad request'}, status: status and return if errors.empty?
    	render json: errors.to_json, status: status  		
  	end

	  def unauthorized!
	    render json: { error: 'not authorized' }, status: :unauthorized
	  end

	  def checkUser?
	  		if request.headers['Authorization']
	  			token = request.headers['Authorization'].split('=')[1]	  			
	  			logger.debug "Checking header token #{token}"
        	@current_user = User.find_by(api_token: token) if token
        end
	  end

  private
  	def authenticate_user!
      logger.debug "Auth token"
      authenticate_token || render_unauthorized
  	end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        @current_user = User.find_by(api_token: token)
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: {:error=>'Bad credentials'}, status: :unauthorized
    end

end