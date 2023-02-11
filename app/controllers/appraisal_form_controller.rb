class AppraisalFormController < ApplicationController
    before_action :authorize_request
    # before_action :find_user, except: %i[create index]
    def get_quarterly_appraisal 
        if @current_employee.role == "Manager" || @current_employee.role == "Employee"
            find_appraisal = QuarterlyAppraisal.find_by(year: params[:year],quarter: params[:quarter],employee_id: @current_employee.id)
            if find_appraisal.present?
                render json:find_appraisal, status: 200
            else
                render json:{message:"Does not find quarterly appraisal with given information",quarterly_summary:" "}, status: 404
            end
        else
            render json:{message:"Only Manager and Employee can access this resource"}, status: 400
        end
    end

    def create
        if @current_employee.role == "Employee" || @current_employee.role == "Manager"
            # binding.pry 
            unless form_params[:status] == "Submit"
                dup = QuarterlyAppraisal.find_by(employee_id: @current_employee.id,
                quarter: find_appraisal[:quarter],year: find_appraisal[:year])
                if dup.present? 
                    render json:{message:"For this year and quarter, your appraisal is already created"},created_appraisal: dup, status: 200
                else
                    create_appraisal = QuarterlyAppraisal.new(form_params)
                    create_appraisal.employee_id = @current_employee.id
                    create_appraisal.year = find_appraisal[:year]
                    create_appraisal.quarter = find_appraisal[:quarter]
                    if create_appraisal.save
                        # NotificationMailerJob.perform_later(@current_employee.id)
                        render json:{message:"Appraisal created successfully",id: create_appraisal.id,
                        quarterly_summary: create_appraisal.quarterly_summary}, status: 201
                    else
                        render json:{message:"Failed to created new appraisal"}, status: 400
                    end
                end
                
            else   
                dup = QuarterlyAppraisal.find_by(employee_id: @current_employee.id,
                quarter: find_appraisal[:quarter],year: find_appraisal[:year])
                if dup.present? 
                    render json:{message:"For this year and quarter, your appraisal is already created"},created_appraisal: dup, status: 200
                else
                    create_appraisal = QuarterlyAppraisal.new(form_params)
                    create_appraisal.employee_id = @current_employee.id
                    create_appraisal.year = find_appraisal[:year]
                    create_appraisal.quarter = find_appraisal[:quarter]
                    if create_appraisal.save
                        create_history
                        # NotificationMailerJob.perform_later(@current_employee.id)
                        render json:{message:"Appraisal submitted succcessfully",id: create_appraisal.id,
                        quarterly_summary: create_appraisal.quarterly_summary}, status: 201
                    else
                        render json:{message:"Failed to created new appraisal"}, status: 400
                    end
                end
            end

        else
            render json:{message:"Only Employee and Manager can access this resource"}, status: 400
        end
    end

    def update
        if @current_employee.role == "Employee" || @current_employee.role == "Manager"
            appraisal = QuarterlyAppraisal.find_by(id: params[:appraisal_id],employee_id: @current_employee.id)
            # puts "-----------#{params[:action]}-------------"
            if appraisal.present?
                if appraisal.update(form_params)
                    if form_params[:status] == "Submit"
                        create_history
                        render json:{message:"Appraisal submitted succcessfully",id: appraisal.id,
                        quarterly_summary: appraisal.quarterly_summary}, status: 201
                    else  
                        render json:{message:"Appraisal update successfully",id: appraisal.id,
                        quarterly_summary: appraisal.quarterly_summary}, status: 201
                    end
                else
                    render json:{message:"Failed to update quarterly appraisal"}, status: 400
                end
            else
                render json:{message:"Appraisal not found",quarterly_summary:" "}, status: :bad_request
            end
        else
            render json:{message:"Only Employee and Manager can access this resources"}, status: 400
        end
    end


    def create_history
        history = History.new(history_params)
        history["quarter"] = find_appraisal[:quarter]
        history["event"] = form_params[:status]
        history["year"] = find_appraisal[:year]
        history["employee_id"] = @current_employee.id
        history["summary"] = form_params[:quarterly_summary]
        history["associated_manager"] = @current_employee.associated_manager_id
        history["submitted_date"] = Time.now
        if @current_employee.role == "Employee"
            history["submitted_by"] = @current_employee.role
        else
            history["submitted_by"] = "Employee"
        end
        history.save
    end


    private
    def find_appraisal
        params.require(:find_quarterly_appraisal).permit(:year,:quarter)
    end
    def form_params
        params.require(:form_field).permit(:quarterly_summary,:status)
        # binding.pry
    end 
    def history_params 
        params.require(:history_field).permit(:annual_flag)
    end
end