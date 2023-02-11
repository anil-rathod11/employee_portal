class AnnualAppraisalFormController < ApplicationController
    before_action :authorize_request
    def create
        # binding.pry
        if @current_employee.role == "Employee"
            find = AnnualSummary.find_by(year: find_annual_appraisal[:year],employee_id: @current_employee.id)
            if find.present?
                render json:{message:"Your annual appraisal already created"}, status: 400
            else
                annual_appraisal = AnnualSummary.new(annual_form_field)
                annual_appraisal.employee_id = @current_employee.id
                annual_appraisal.year = find_annual_appraisal[:year]
            # binding.pry
                if annual_appraisal.save
                    create_annual_history
                    render json:{message:"Annual appraisal created successfully"}, status: 201
                else
                    render json:{message:"Failed to create annual appraisal"}, status: 400
                end
            end
        else
            render json:{message:"Only emplpoyee can access this resources"}, status: 400
        end
    end

    def update
        annual_appraisal = AnnualSummary.find_by(id: params[:id])
        if annual_appraisal.update(annual_form_field)
            create_annual_history
            render json:{message:"Annual form updated successfully"}, status: 201
        else
            render json:{message:"Failed to update record"}, status: 400
        end
    end

    def create_annual_history
        if history_params[:annual_flag] 
            annual_history = History.new(history_params)
            # annual_history["annual_flag"] = form_params[:annual_flag]
            annual_history["year"] = find_annual_appraisal[:year]
            annual_history["employee_id"] = @current_employee.id
            # annual_summary = {accumplishment: annual_remark_form[:accumplishment],development_need: annual_remark_form[:development_need],career_goals: annual_remark_form[:career_goals]}
            # json_text = JSON.generate(annual_summary)
            # annual_history["summary"] = history_params[:annual_summary]
            annual_history["associated_manager"] = @current_employee.associated_manager
            annual_history["submitted_date"] = Time.now
            annual_history.save
        end
    end

    private
    # def form_params
    #     params.require(:annual_form).permit(:id,:year,:accumplishment,:development_need,:career_goals)
    # end
    def history_params 
        params.require(:history_field).permit(:event, :annual_flag,:summary)
    end
    def find_annual_appraisal 
        params.require(:find_annual_appraisal_params).permit(:year)
    end
    def annual_form_field
        params.require(:annual_remark_form_field).permit(:accumplishment, :development_need, :career_goals)
    end 
end