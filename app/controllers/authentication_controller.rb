class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login
  
    # POST /auth/login
    def login
        begin
            @user = Employee.find_by_email!(params[:email])
        rescue ActiveRecord::RecordNotFound
            render json:{message:"Invalid Email"}, status: 400
        end
        if @user
            if @user.authenticate(params[:password])
                token = JsonWebToken.encode(user_id: @user.id)
                time = Time.now + 24.hours.to_i
                render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),name: @user.name,role:@user.role}, status: :ok
            else
                render json: { error: 'Invalid Password' }, status: :unauthorized
            end
        end
    end
  
    private
  
    def login_params
        params.permit(:email, :password)
    end
end