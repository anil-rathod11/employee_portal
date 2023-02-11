class EmployeeController < ApplicationController
  before_action :authorize_request, except: :create

  def create
    if @current_employee.role == "Super Admin"
      if password1 == password2
        employee = Employee.new(employee_params)
        if employee.save
          puts "anil #{ENV["deploy_server_ip"]}, #{ENV["RDS_DB_NAME"]}"
          render json:{message:"Employee created successfully"}, status: 201
        else
          render json:{message:employee.errors.full_messages}, status: 400
        end
      else
        render json:{message:"Password does not match"},status: 400
      end
    else
      render json:{message:"Only super can create employee"}, status: 400
    end
  end

  def forgot
    if params[:email].blank? 
      return render json: {error: 'Email not present'}
    end

    employee = Employee.find_by(email: params[:email])
    if employee.present?
    
      PasswordMailer.with(employee: employee).reset.deliver_now
      render json: {employee_details: employee}, status: :ok

    else
      render json: {error:'Email address not found. Please check and try again.'}, status: :not_found
    end

  end

  def change_password 
    employee = Employee.find_by(reset_password_token: params[:token])
    if employee.present? && employee.password_token_valid?
      if params[:password] == params[:password_confirmation]
        employee.reset_password(params[:password])
        render json: {password_status: "Password change successfully"}, status: :ok
      end

    else
      render json: {employee_status: "Token not valid with employee"}, status: :bad_request
    end
  end

  private

  def employee_params
    params.require(:create_employee_field).permit(:name,:email,:password1,:password2,:role,:date_of_joining,:designation,:associated_manager_id)
  end
end