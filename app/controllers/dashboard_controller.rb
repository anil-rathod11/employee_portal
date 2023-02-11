class DashboardController < ApplicationController
    before_action :authorize_request
    def employee_dashboard
        # Testing deployement to EC2 instance!!!!!
        if @current_employee.role == "Employee"
            todays_ping_to_employee = History.where(employee_id:@current_employee.id,:submitted_by => ["Manager","Super Admin"],submitted_date: Time.parse("12am")..Time.parse("11:59pm"))
            if todays_ping_to_employee.present?
                render json:{one_day_noti: todays_ping_to_employee.order(submitted_date: :desc)}, status: 200
            else
                render json:{message:"No any latest update for you!"}, status: 404
            end
        elsif @current_employee.role == "Manager"
            super_admin_review = []
            History.where(associated_manager: @current_employee.id,submitted_by:"Employee",submitted_date: Time.parse("12am")..Time.parse("11:59pm")).each do |object|
                super_admin_review = super_admin_review + (History.where(employee_id:object.employee_id,submitted_by:"Super Admin",submitted_date: Time.parse("12am")..Time.parse("11:59pm")))
            end
            # binding.pry
            todays_ping_to_manager = History.where(associated_manager: @current_employee.id,submitted_by:"Employee",submitted_date: Time.parse("12am")..Time.parse("11:59pm")).or(History.where(employee_id:@current_employee.id,
            submitted_by:"Super Admin",submitted_date: Time.parse("12am")..Time.parse("11:59pm")))
            todays_ping_to_manager = todays_ping_to_manager + super_admin_review
            # binding.pry
            def sort_by_date(todays_ping_to_manager)
                todays_ping_to_manager.sort_by { |h| h["submitted_date"] }
                # binding.pry
            end
            # todays_ping_to_manager.reverse
            if todays_ping_to_manager.present?
                # binding.pry
                render json:{one_day_noti: sort_by_date(todays_ping_to_manager).reverse}, status: 200
            else
                render json:{message:"No any latest update for you!"}, status: 404
            end
        else
            todays_ping_to_admin = History.where(submitted_date: Time.parse("12am")..Time.parse("11:59pm"),
            :submitted_by => ["Manager","Employee"])
            if todays_ping_to_admin.present?
                render json:{one_day_noti: todays_ping_to_admin.order(submitted_date: :desc)}, status: 200
            else
                render json:{message:"No any latest update for you!"}, status: 404
            end
        end
        
    end
end