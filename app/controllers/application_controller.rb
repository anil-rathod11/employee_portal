class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  attr_accessor :current_employee
 
  # before_action :authenticate_request 
  def index
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_employee = Employee.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      # binding.pry
      render json: { errors: e.message }, status: :unauthorized
    end
  end


  # before_action :cors_set_access_control_headers
  def cors_preflight_check
    return unless request.method == 'OPTIONS'
    cors_set_access_control_headers
    render json: {}, status: 200
  end
  

  protected
  
  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    # binding.pry
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers, ngrok-skip-browser-warning'
    response.headers['Access-Control-Max-Age'] = '1728000'
    response.headers['Access-Control-Allow-Credentials'] = true
    response.headers['ngrok-skip-browser-warning'] = true
    # response.headers['Access-Control-Request-Method'] = ''
  end
end
