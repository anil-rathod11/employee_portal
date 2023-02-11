class ManagerController < ApplicationController
    before_action :authorize_request
    # attr_accessor :history_object
    def get_appraisal_form_by_reviewer 
        if @current_employee.role == "Manager"
            history_object = History.find(params[:history_id])
            # binding.pry
            if history_object.present?
                appraisal = QuarterlyAppraisal.find_by(year:history_object.year,quarter:history_object.quarter,
                employee_id:history_object.employee_id)
                # puts appraisal.id
                if appraisal.present? && history_object.submitted_by == "Manager"
                    id = {}
                    id["manager_review_id"] = 0
                    id["admin_review_id"] = 0
                    QuarterlyAppraisalRemark.where(quarterly_appraisal_id:appraisal.id).each do |object|
                        if object.designation == "Manager"
                            id["manager_review_id"] = object.reviewer_id
                        else
                            id["admin_review_id"] = object.reviewer_id
                        end
                    end
                    manager_review = QuarterlyAppraisalRemark.find_by(reviewer_id: id["manager_review_id"], quarterly_appraisal_id: appraisal.id)
                    admin_review = QuarterlyAppraisalRemark.find_by(reviewer_id: id["admin_review_id"], quarterly_appraisal_id: appraisal.id)
                    # puts manager_review.id
                    if manager_review.present? && admin_review.present?
                        # binding.pry
                        manager_review = manager_review.attributes
                        admin_review = admin_review.attributes
                        admin_review["admin_name"] = Employee.find(id["admin_review_id"]).name
                        manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                        render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 200
                    else
                        manager_review = manager_review.attributes
                        manager_review["manager_name"] = @current_employee.name
                        render json:{response:{manager_response: manager_review,admin_response: ""}},status: 200
                    end

                else
                    id = {}
                    id["manager_review_id"] = 0
                    id["admin_review_id"] = 0
                    QuarterlyAppraisalRemark.where(quarterly_appraisal_id:appraisal.id).each do |object|
                        if object.designation == "Manager"
                            id["manager_review_id"] = object.reviewer_id
                        else
                            id["admin_review_id"] = object.reviewer_id
                        end
                    end
                    manager_review = QuarterlyAppraisalRemark.find_by(reviewer_id: id["manager_review_id"], quarterly_appraisal_id: appraisal.id)
                    admin_review = QuarterlyAppraisalRemark.find_by(reviewer_id: id["admin_review_id"], quarterly_appraisal_id: appraisal.id)
                    # puts manager_review.id
                    if manager_review.present? && admin_review.present?
                        # binding.pry
                        manager_review = manager_review.attributes
                        admin_review = admin_review.attributes
                        admin_review["admin_name"] = Employee.find(id["admin_review_id"]).name
                        manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                        render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 200
                    elsif manager_review.present?
                        manager_review = manager_review.attributes
                        manager_review["manager_name"] = @current_employee.name
                        render json:{response:{manager_response: manager_review,admin_response: ""}},status: 200
                    else
                        manager_review = {}
                        manager_review["quarterly_appraisal_id"] = appraisal.id
                        manager_review["manager_name"] = @current_employee.name
                        render json:{response:{manager_response: manager_review,admin_response: ""}},status: 200
                    end                        
                end 
            else
                render json:{message:"History object not found with given id"}, status: 404
            end

        elsif @current_employee.role == "Super Admin"
            history_object = History.find(params[:history_id])
            # binding.pry
            if history_object.present?
                appraisal = QuarterlyAppraisal.find_by(year:history_object.year,quarter:history_object.quarter,
                employee_id:history_object.employee_id)
                # puts appraisal.id
                if appraisal.present?
                    if history_object.submitted_by == "Super Admin"
                        reviewer_form = QuarterlyAppraisalRemark.find_by(reviewer_id: Employee.find(appraisal.employee_id).associated_manager_id, quarterly_appraisal_id: appraisal.id)
                        admin_response = QuarterlyAppraisalRemark.find_by(reviewer_id: history_object.associated_manager, quarterly_appraisal_id: appraisal.id)
                        # puts reviewer_form.id
                        if reviewer_form.present? && admin_response.present?
                            # binding.pry
                            manager_review = reviewer_form.attributes
                            admin_review = admin_response.attributes
                            admin_review["admin_name"] = @current_employee.name
                            manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                            render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 200
                        elsif reviewer_form.present?
                            manager_review = reviewer_form.attributes
                            admin_review = {}
                            manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                            admin_review["quarterly_appraisal_id"] = appraisal.id
                            admin_review["admin_name"] = @current_employee.name
                            admin_review['quarterly_summary_response_by_reviewer'] = ""
                            render json:{response:{manager_response: manager_review,admin_response: admin_review}},status: 200
                        else
                            manager_review = {}
                            manager_review["quarterly_appraisal_id"] = appraisal.id
                            manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                            manager_review["quarterly_summary_response_by_reviewer"] = ""
                            admin_review = {}
                            admin_review["admin_name"] = @current_employee.name
                            admin_review["quarterly_summary_response_by_reviewer"] = ""
                            admin_review["quarterly_appraisal_id"] = appraisal.id
                            render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 404
                        end
                    else
                        if history_object.submitted_by == "Manager"
                            reviewer_form = QuarterlyAppraisalRemark.find_by(reviewer_id: history_object.associated_manager, quarterly_appraisal_id: appraisal.id)
                            admin_response = QuarterlyAppraisalRemark.find_by(reviewer_id:@current_employee.id, quarterly_appraisal_id: appraisal.id)
                            # puts reviewer_form.id
                            if reviewer_form.present? && admin_response.present?
                                # binding.pry
                                manager_review = reviewer_form.attributes
                                admin_review = admin_response.attributes
                                admin_review["admin_name"] = @current_employee.name
                                manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                                render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 200
                            elsif reviewer_form.present?
                                manager_review = reviewer_form.attributes
                                admin_review = {}
                                manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                                admin_review["quarterly_appraisal_id"] = appraisal.id
                                admin_review["admin_name"] = @current_employee.name
                                admin_review['quarterly_summary_response_by_reviewer'] = ""
                                render json:{response:{manager_response: manager_review,admin_response: admin_review}},status: 200
                            else
                                manager_review = {}
                                manager_review["quarterly_appraisal_id"] = appraisal.id
                                manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                                manager_review["quarterly_summary_response_by_reviewer"] = ""
                                admin_review = {}
                                admin_review["admin_name"] = @current_employee.name
                                admin_review["quarterly_summary_response_by_reviewer"] = ""
                                admin_review["quarterly_appraisal_id"] = appraisal.id
                                render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 404
                            end
                        else
                            reviewer_form = QuarterlyAppraisalRemark.find_by(reviewer_id: history_object.associated_manager, quarterly_appraisal_id: appraisal.id)
                            admin_response = QuarterlyAppraisalRemark.find_by(reviewer_id:@current_employee.id, quarterly_appraisal_id: appraisal.id)
                            # puts reviewer_form.id
                            if reviewer_form.present? && admin_response.present?
                                # binding.pry
                                manager_review = reviewer_form.attributes
                                admin_review = admin_response.attributes
                                admin_review["admin_name"] = @current_employee.name
                                manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                                render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 200
                            elsif reviewer_form.present?
                                manager_review = reviewer_form.attributes
                                admin_review = {}
                                manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                                admin_review["quarterly_appraisal_id"] = appraisal.id
                                admin_review["admin_name"] = @current_employee.name
                                admin_review['quarterly_summary_response_by_reviewer'] = ""
                                render json:{response:{manager_response: manager_review,admin_response: admin_review}},status: 200
                            else
                                manager_review = {}
                                manager_review["quarterly_appraisal_id"] = appraisal.id
                                manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                                manager_review["quarterly_summary_response_by_reviewer"] = ""
                                admin_review = {}
                                admin_review["admin_name"] = @current_employee.name
                                admin_review["quarterly_summary_response_by_reviewer"] = ""
                                admin_review["quarterly_appraisal_id"] = appraisal.id
                                render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 404
                            end
                        end

                    end

                else
                    render json:{message:"For this year and quarter employee has no record"}, status: 400
                end
            else
                render json:{message:"History object not found with given id"}, status: 404
            end

        elsif @current_employee.role == "Employee"
            history_object = History.find(params[:history_id])
            if history_object.present?
                appraisal = QuarterlyAppraisal.find_by(year:history_object.year,quarter:history_object.quarter,
                employee_id:history_object.employee_id)
                if appraisal.present?
                    if appraisal.present? && history_object.submitted_by == "Employee"
                        id = {}
                        id["manager_review_id"] = 0
                        id["admin_review_id"] = 0
                        QuarterlyAppraisalRemark.where(quarterly_appraisal_id:appraisal.id).each do |object|
                            if object.designation == "Manager"
                                id["manager_review_id"] = object.reviewer_id
                            else
                                id["admin_review_id"] = object.reviewer_id
                            end
                        end
                        manager_review = QuarterlyAppraisalRemark.find_by(reviewer_id: id["manager_review_id"], quarterly_appraisal_id: appraisal.id)
                        admin_review = QuarterlyAppraisalRemark.find_by(reviewer_id: id["admin_review_id"], quarterly_appraisal_id: appraisal.id)
                        # puts manager_review.id
                        if manager_review.present? && admin_review.present?
                            # binding.pry
                            manager_review = manager_review.attributes
                            admin_review = admin_review.attributes
                            admin_review["admin_name"] = Employee.find(id["admin_review_id"]).name
                            manager_review["manager_name"] = Employee.find(history_object.associated_manager).name
                            render json:{response:{manager_response: manager_review,admin_response: admin_review}}, status: 200
                        else
                            manager_review = manager_review.attributes
                            manager_review["manager_name"] = @current_employee.name
                            render json:{response:{manager_response: manager_review,admin_response: ""}},status: 200
                        end
                    end
                else
                    render json:{message:"Employee appraisal not found with given id"}, status: 404
                end
            else
                render json:{message:"History not find with given id"}, status: 404
            end
        else
            render json:{message:"Only employee,manager and super admin acn access this resource"}, status: 400
        end
    end

    def update_appraisal_form_only_reviewer
        if @current_employee.role == "Manager" || @current_employee.role == "Super Admin"
            find_review = QuarterlyAppraisalRemark.find(params[:quarterly_appraisal_remarks_id])
            if find_review.present?
                # binding.pry
                if find_review.update(form_field_for_reviewer)
                    # puts find_review.id
                    if form_field_for_reviewer[:status] == "Submit" 
                        summary = QuarterlyAppraisal.find(find_review.quarterly_appraisal_id).quarterly_summary
                        create_history_for_reviewer(summary)
                        if @current_employee.role == "Super Admin"
                            find_review = find_review.attributes
                            find_review["admin_name"] = Employee.find(@current_employee.id).name
                            render json: {message:"Remark submitted successfully", admin_response: find_review}, status: 200
                        else
                            find_review = find_review.attributes
                            find_review["manager_name"] = Employee.find(@current_employee.id).name
                            render json: {message:"Remark submitted successfully", manager_response: find_review}, status: 200    
                        end      
                    else
                        if @current_employee.role == "Super Admin"
                            find_review = find_review.attributes
                            find_review["admin_name"] = Employee.find(@current_employee.id).name
                            render json: {message:"Remark updated successfully", admin_response: find_review}, status: 200
                        else
                            find_review = find_review.attributes
                            find_review["manager_name"] = Employee.find(@current_employee.id).name
                            render json: {message:"Remark updated successfully", manager_response: find_review}, status: 200
                        end
                    end
                else
                    render json:{message:"Failed to update review form"}, status: 400
                end
            else
                render json:{message:"Reviewer form not present"}, status: 404
            end
        else
            render json:{message:"Only manager can access this resource"}, status: 400
        end

    end



    def create_appraisal_form_only_reviewer 
        if @current_employee.role == "Manager" || @current_employee.role == "Super Admin"
            appraisal = QuarterlyAppraisal.find_by(find_appraisal)
            if appraisal.present?
                reviewer_form = QuarterlyAppraisalRemark.find_by(quarterly_appraisal_id: appraisal.id, reviewer_id: @current_employee.id)
                unless reviewer_form.present?
                    form = QuarterlyAppraisalRemark.new(form_field_for_reviewer)
                    form["quarterly_appraisal_id"] = appraisal.id
                    form["reviewer_id"] = @current_employee.id
                    form["designation"] = @current_employee.role
                    # binding.pry
                    if form.save
                        # create_history_for_reviewer
                        if form_field_for_reviewer[:status] == "Submit"
                            summary = appraisal.quarterly_summary
                            create_history_for_reviewer(summary)
                            if @current_employee.role == "Super Admin"
                                form = form.attributes
                                # form[:quarterly_summary_response_by_admin] = form.delete :quarterly_summary_by_reviewer
                                form["admin_name"] = Employee.find(@current_employee.id).name
                                render json:{message:"Admin response submitted successfully",admin_response: form}, status: 200
                            else
                                form = form.attributes
                                form["manager_name"] = Employee.find(@current_employee.id).name
                                render json:{message:"Manager response submitted successfully",manager_response: form}, status: 200  
                            end                           
                        else
                            if @current_employee.role == "Super Admin"
                                form = form.attributes
                                form["admin_name"] = Employee.find(@current_employee.id).name
                                # form[:quarterly_summary_response_by_admin] = form.delete :quarterly_summary_by_reviewer
                                render json:{message:"Admin response created successfully",admin_response: form}, status: 200
                            else
                                form = form.attributes
                                form["manager_name"] = Employee.find(@current_employee.id).name
                                render json:{message:"Manager response created successfully",manager_response: form}, status: 200 
                            end
                        end                              
                    else
                        render json:{message:"Failed to create response"}, status: 400
                    end
                else
                    render json:{message: "Your response already created please check your response"}, status: :bad_request
                end
            else
                render json:{message:"Employee appraisal not created yet!"}, status: 404
            end
        else
            render json:{message:"Only manager and super admin can access this resources"}, status: :bad_request
        end

    end

    def search_history
        if @current_employee.role == "Manager"
            employee = Employee.find_by(name: params[:name])
            if employee.present?
                # name = employee.name
                employee_history = History.where(employee_id: employee.id, associated_manager: @current_employee.id).order(:submitted_date).page(params[:page])
                # History.order(:submitted_date).page(params[:page])
                # binding.pry
                if employee_history.present?
                    # binding.pry
                    history_hash = []
                    total_history_count = History.where(employee_id: employee.id, associated_manager: @current_employee.id).order(:submitted_date).count
                    employee_history.each do |data|
                        data = data.attributes
                        data["employee_name"] = Employee.find(data["employee_id"]).name
                        if data["submitted_by"] == "Manager"
                            data["submitted_by"] = Employee.find(data["associated_manager"]).role
                            history_hash.push(data)
                        else
                            data["submitted_by"] = Employee.find(data["employee_id"]).role
                            history_hash.push(data)
                        end
                    end
                    render json:{total_history_count: total_history_count, record_per_page: history_hash}, status: 200
                else
                    total_history_count = History.where(employee_id: employee.id,associated_manager: @current_employee.id).order(:submitted_date).count
                    render json:{message:"Employee history not found",total_history_count: total_history_count, record_per_page: employee_history}, status: 404
                end
            else
                render json:{message:"Employee not found"}, status: 404
            end
        else
            render json:{message:"Only manager can access this resource"}, status: 400
        end
    end

    def get_history_by_page
        if (@current_employee.role == "Manager" && params[:which_one] == "under") ||
            (@current_employee.role == "Super Admin" && params[:which_one] == "under") 
            page_hash = []
            array1 = History.where(associated_manager: @current_employee.id)
            total_history_count = array1.count
            array1.order(submitted_date: :desc).page(params[:page]).each do |object|
                object = object.attributes
                object["employee_name"] = Employee.find(object["employee_id"]).name
                if object["submitted_by"] == "Manager"
                    # object["submitted_by"] = Employee.find(object["associated_manager"]).role
                    object["submitted_by"] = "Manager"
                    page_hash.push(object)
                else
                    object["submitted_by"] = Employee.find(object["employee_id"]).role
                    page_hash.push(object)
                end
            end
            render json:{total_history_count: total_history_count,record_per_page: page_hash}, status: 200
        elsif (@current_employee.role == "Super Admin" && params[:which_one] == "reviewed") || 
            (@current_employee.role == "Manager" && params[:which_one] == "reviewed")
            total_history_count = total_history_count = History.where(associated_manager: @current_employee.id,submitted_by:@current_employee.role).order(submitted_date: :desc).count
            employee_hash = []
            # binding.pry
            History.where(associated_manager: @current_employee.id,submitted_by:@current_employee.role).order(submitted_date: :desc).page(params[:page]).each do |data|
                data = data.attributes
                data["employee_name"] = Employee.find(data["employee_id"]).name
                employee_hash.push(data)
            end
            render json:{total_history_count: total_history_count,record_per_page: employee_hash}, status: 200
        elsif (@current_employee.role == "Manager" && params[:which_one] == "not_reviewed")
            total_history_count = 0
            employee_hash = []
            # binding.pry
            History.where(associated_manager: @current_employee.id).order(submitted_date: :desc).page(params[:page]).each do |data|
                # binding.pry
                get_appraisal = QuarterlyAppraisal.find_by(employee_id:data.employee_id,
                quarter:data.quarter,year:data.year)
                check_review = QuarterlyAppraisalRemark.find_by(quarterly_appraisal_id:get_appraisal.id,
                reviewer_id: @current_employee.id)
                unless check_review.present?
                    data = data.attributes
                    data["employee_name"] = Employee.find(data["employee_id"]).name
                    data["submitted_by"] = Employee.find(data["employee_id"]).role
                    employee_hash.push(data)
                    total_history_count = total_history_count + 1
                end
            end
            render json:{total_history_count: total_history_count,record_per_page: employee_hash}, status: 200
        elsif @current_employee.role == "Super Admin" && params[:which_one] == "all"
            all_employee_history = History.all
            history_array = []
            if all_employee_history.present?
                all_employee_history.order(submitted_date: :desc).page(params[:page]).each do |object|
                    object = object.attributes
                    object["employee_name"] = Employee.find(object["employee_id"]).name
                    history_array.push(object)
                end
                render json:{total_history_count: History.count,record_per_page: history_array}, status: 200
            else
                render json:{message:"Missing History",total_history_count: History.count,record_per_page: history_array}, status: 400
            end
        end
    end

    def create_history_for_reviewer(summary)
        appraisal= QuarterlyAppraisal.find_by(find_appraisal)
        history = History.new(history_params)
        history["event"] = form_field_for_reviewer[:status]
        history["quarter"] = find_appraisal[:quarter]
        history["year"] = find_appraisal[:year]
        history["employee_id"] = appraisal.employee_id
        history["submitted_by"] = @current_employee.role
        # puts "-----#{history_object.summary}------"
        
        history["summary"] = summary
        if @current_employee.role == "Super Admin"
            history["associated_manager"] = @current_employee.id
        else
            history["associated_manager"] = Employee.find(appraisal.employee_id).associated_manager_id
        end
        history["submitted_date"] = Time.now
        history.save
    end
    
    private
    def find_appraisal
        params.require(:find_quarterly_appraisal).permit(:year,:quarter,:employee_id)
    end
    def form_field_for_reviewer 
        params.require(:form_field_to_reviewer).permit(:quarterly_summary_by_reviewer, :status)
    end
    def history_params 
        params.require(:history_field).permit(:annual_flag)
    end

end