class ErrorsController < ActionController::Base
  def not_found
    if env["REQUEST_PATH"] =~ /^\/api/
      render json: {:error => 'Path not found'}, status: :not_found
    else
      render text: "404 Not found", status: :not_found
    end
  end

  def exception
    if env["REQUEST_PATH"] =~ /^\/api/
      render json: {:error => 'Internal server error'}, status: :internal_server_error
    else
      render text: "500 Internal Server Error", status: :internal_server_error
    end
  end
end