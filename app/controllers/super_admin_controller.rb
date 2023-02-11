class SuperAdminController < ApplicationController
    before_action :authorize_request

    def create_project
        if @current_employee.role == "Admin"
            project = Project.new(project_params)
            if project.save
                render json:{message:"Project created successfully"}, status: 201
            else
                render json:{message:project.errors.full_messages}, status: 400
            end
        else
            render json:{message:"Only super admin can access this resource"}, status: 400
        end
    end

    def create_employee 
        if @current_employee.role == "Admin"
            begin
                if employee_params[:password] == employee_params[:password_confirmation]
                    new_employee = Employee.new(employee_params)
                    if new_employee.valid?
                        new_employee.save 
                        puts "anil #{ENV["deploy_server_ip"]}, #{ENV["RDS_DB_NAME"]}"
                        render json:{message:"Employee created successfully",employee_details: new_employee}, status: 201
                    else
                        render json:{message:new_employee.errors.full_messages}, status: 400
                    end
                else
                    render json:{message:"Password does not match"}, status: 400
                end
            rescue StandardError => e
                render json:{message:e.message}, status: 400
            end

        else
            render json:{message:"Only Super admin can access this resources"}, status: 400
        end
    end

    def employee_list 
        if @current_employee.role == "Admin"
            employees = Employee.all.where("id NOT IN(?)", @current_employee.id)
            count = employees.count
            employees = employees.page(params[:page])
            count_per_page = employees.count
            if employees.present?
                render json:{total_count_of_employee:count,list_of_all_employee: employees}, status: 200
            elsif count_per_page == 0
                render json:{message:"No more list of employee"}, status: 400
            else
                render json:{message:"Employee not created yet!"}, status: 400
            end
        else
            render json:{message:"Only super admin can access this resource"}, status: 400
        end
    end

    def delete_employee
        if @current_employee.role == "Admin"
            begin
                employee = Employee.find(params[:employee_id])
            rescue ActiveRecord::RecordNotFound => e
                return render json:{message:e.message},status: 404
            end
            if employee.update(is_archive: true)
                render json:{message:"Employee archived succcessfully"}, status: 200
            else
                render json:{message:employee.errors.full_messages}, status: 400
            end
        else
            render json:{message:"Only admin can access this action"}, status: 400
        end
    end

    def permanent_delete_employee
        if @current_employee.role == "Admin"
            begin
                employee = Employee.find(params[:employee_id])
            rescue ActiveRecord::RecordNotFound => e
                return render json:{message:e.message},status: 404
            end
            if employee.is_archive == true
                employee.destroy
                render json:{message:"Employee deleted succcessfully"}, status: 200
            else
                render json:{message:"Wrong permanent delete employee request"}, status: 400
            end
        else
            render json:{message:"Only admin can access this action"}, status: 400
        end
    end

    def create_annual_appraisal_for_remark 
        if @current_employee.role == "Admin"
            find_annual_appraisal = AnnualSummary.find_by(find_annual_app)
            find_annual_appraisal_remark = AnnualSummaryRemark.find_by(annual_summary_id: find_annual_appraisal.id,
            reviewer_id: @current_employee.id)
            if find_annual_appraisal_remark.present?
                render json:{message: "Your response already created for this employee"}, status: 400
            else
                create_remark_appraisal = AnnualSummaryRemark.new(annual_remark_form)
                create_remark_appraisal["reviewer_id"] = @current_employee.id
                create_remark_appraisal["designation"] = @current_employee.role 
                create_remark_appraisal["annual_summary_id"] = find_annual_appraisal.id
                # binding.pry
                if create_remark_appraisal.save
                    render json:{message:"Super Admin response created successfully"}, status: 201
                else
                    render json:{message:"Failed to create response"}, status: 400
                end
            end
        elsif @current_employee.role == "Manager"
            find_annual_appraisal = AnnualSummary.find_by(find_annual_app)
            find_annual_appraisal_remark = AnnualSummaryRemark.find_by(annual_summary_id: find_annual_appraisal.id,
            reviewer_id: @current_employee.id)
            if find_annual_appraisal.present?
                render json:{message: "Your response already created for this employee"}, status: 400
            else
                create_annual_appraisal = AnnualSummaryRemark.new(annual_form_field)
                create_annual_appraisal["employee_id"] = find_annual_appraisal.employee_id
                if create_annual_appraisal.save
                    render json:{message:"Annual appraisal created successfully",annual_form: create_annual_appraisal}, status: 201
                else
                    render json:{message:"Failed to create response"}, status: 400
                end
                render json:{message:"Only Super Admin can access this resource"}, status: 401
            end
        end
    end

    def create_quarterly_appraisal_for_remark 
        if @current_employee.role == "Admin" && @current_employee.role == "Manager"
            find_appraisal = QuarterlyAppraisal.find_by(find_quarterly_appraisal)
            if find_appraisal.present?
                # binding.pry
                find_quarterly_remark = QuarterlyAppraisalRemark.find_by(quartely_appraisal_id: find_appraisal.id,
                reviewer_id: @current_employee.id)
                if find_quarterly_remark.present?
                    render json:{message: "Your response already created for this employee"}, status: 400
                else
                    create_remark_appraisal = QuarterlyAppraisalRemark.new(quarterly_remark_form)
                    create_remark_appraisal["reviewer_id"] = @current_employee.id
                    create_remark_appraisal["designation"] = @current_employee.role 
                    create_remark_appraisal["quartely_appraisal_id"] = find_appraisal.id
                    # binding.pry
                    if create_remark_appraisal.save
                        create_history
                        render json:{message:"Super Admin response created successfully"}, status: 201
                    else
                        render json:{message:"Failed to create response"}, status: 400
                    end
                end
            else
                render json:{message:"For this quarter employee has no record"}, status: 400
            end
        else
            render json:{message:"Only Admin can access this resource"}, status: 401
        end
    end

    def destroy_annual_appraisal 
        if @current_employee.role == "Admin"
            del = AnnualSummary.find_by(employee_id: params[:employee_id, year: params[:year]])
            # del = AnnualSummary.find_by(id: params[:id])
            if del.present?
                if del.destroy
                    render json:{message:"annual response deleted successfully"}, status: 200
                else
                    render json: {message:"Failed to delete record"}, status: 400
                end
            else
                render json:{message:"Record not found"}, status: 404
            end
        else
            render json:{message:"Only Super admin can access thid resource"}, status: 400
        end
    end
    def soft_delete_employee_appraisal_data 
        if @current_employee.role == "Admin"
            employee_appraisal_data = QuarterlyAppraisal.where(employee_id: params[:employee_id], year: params[:year])
            # id = employee_appraisal_data.ids
            if employee_appraisal_data.present?
                employee_appraisal_data.each do |set_archive|
                    set_archive.update(archive: true)
                end
                employee_appraisal_history = History.where(year: params[:year],employee_id: params[:employee_id])
                # binding.pry
                if employee_appraisal_history.present?
                    employee_appraisal_history.each do |set_archive1|
                        set_archive1.update(archive: "is_archive")
                        # puts set_archive1.archive
                    end
                    render json:{message:"Quarterly response archived successfully",role: @current_employee.role}, status: 200
                end
            else
                render json:{message:"Employee quarterly appraisall data not found"}, status: 404
            end
        else
            render json:{message:"Only Super admin can access thid resource"}, status: 400
        end
    end

    def permanent_delete_employee_appraisal_data 
        if @current_employee.role == "Admin"
            employee_appraisal = QuarterlyAppraisal.where(employee_id: params[:employee_id], archive: true)
            name = Employee.find_by(id: employee_id).name
            if employee_appraisal.present?
                employee_appraisal.destroy_all
                render json:{message:"Employee record deleted permanentlys", employee_name: name}, status: 200
            else
                render json:{message:"Employee record does not exit"}, status: 404
            end
        else
            render json:{message:"Only Super Admin can access this resource"}, status: 400
        end
    end

    def create_history
        require "json"
        if history_params[:annual_flag] 
            annual_history = History.new(history_params)
            # annual_history["annual_flag"] = form_params[:annual_flag]
            annual_history["year"] = annual_remark_form[:year]
            annual_history["employee_id"] = annual_remark_form[:employee_id]
            annual_summary = {accumplishment: annual_remark_form[:accumplishment],development_need: annual_remark_form[:development_need],career_goals: annual_remark_form[:career_goals]}
            # json_text = JSON.generate(annual_summary)
            annual_history["summary"] = JSON.dump(annual_summary)
            annual_history["associated_manager"] = @current_employee.id
            annual_history["submitted_date"] = Time.now
            annual_history.save
        else
            quarterly_history = History.new(history_params)
            quarterly_history["year"] = find_quarterly_appraisal[:year]
            quarterly_history["quarter"] = find_quarterly_appraisal[:quarter]
            quarterly_history["employee_id"] = find_quarterly_appraisal[:employee_id]
            quarterly_history["summary"] = quarterly_remark_form[:quarterly_summary_by_reviewer]
            quarterly_history["associated_manager"] = @current_employee.id
            quarterly_history["submitted_date"] = Time.now
            quarterly_history.save
        end
    end      

    private
    def find_annual_app 
        params.require(:find_annual_appraisal_params).permit(:year, :employee_id)
    end
    def annual_remark_form
        params.require(:annual_remark_form_field).permit(:accumplishment_by_reviewer, :development_need_by_reviewer, :career_goals_by_reviewer,:rating)
    end
    def quarterly_remark_form
        params.require(:quarterly_remark_form_field).permit(:quarterly_summary_by_reviewer)
    end 
    def history_params 
        params.require(:history_field).permit(:event, :annual_flag)
    end

    def find_quarterly_appraisal
        params.require(:find_quarterly_appraisal_params).permit(:year,:quarter,:employee_id)
    end

    def employee_params
        params.require(:employee_fields).permit(:name,:email,:role,:password,:password_confirmation,:associated_manager_id,:project_id,:designation,:date_of_birth)
    end

    def project_params
        params.require(:project_fields).permit(:name,:description,:team_size,:project_lead_id,:additional_requirement)
    end
end