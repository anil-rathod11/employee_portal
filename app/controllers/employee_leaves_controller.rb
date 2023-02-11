class EmployeeLeavesController < ApplicationController
    before_action :authorize_request
    def read_leave_app
        # binding.pry
        if @current_employee.role == "Employee" || (@current_employee.role == "Manager" && params[:self] == "true")
            # get_all_leave_app = Empleave.where(employee_id:@current_employee.id)
            get_all_leave_app = Empleave.joins(:employee).where(employee_id:@current_employee.id).order("start_date desc").select('employees.name AS employee_name,
            empleaves.id,empleaves.reason,empleaves.start_date,empleaves.end_date,empleaves.no_of_paid_leave,empleaves.remaining_leaves,empleaves.status,empleaves.half_day')
            if get_all_leave_app.present?
                # binding.pry
                render json:{leaves_app:get_all_leave_app,remaining_leaves:LeaveCounter.find_by(employee_id:@current_employee.id).leaves}, status: 200
            else
                render json:{message:"Not any leave created yet!"}, status: 404
            end
        elsif @current_employee.role == "Manager"
            get_employee_ids = Employee.where(associated_manager_id:@current_employee.id)
            if get_employee_ids.present?
                leaves = Empleave.joins(:employee).where(employee_id:get_employee_ids.ids).order("start_date desc").select('employees.name AS employee_name,
                empleaves.id,empleaves.reason,empleaves.start_date,empleaves.end_date,empleaves.no_of_paid_leave,empleaves.remaining_leaves,empleaves.status,empleaves.half_day')
                if leaves.present?
                    render json:{leaves_app:leaves}, status: 200
                else
                    render json:{message:"Employee don't have any leave"}, status: 404
                end
            else
                render json:{message:"You don't assigned any employee"}, status: 400
            end
        elsif @current_employee.role == "Admin"
            get_employee_ids = Employee.where(associated_manager_id:@current_employee.id)
            if get_employee_ids.present?
                leaves = Empleave.where(employee_id:get_employee_ids.ids).order("start_date desc")
                if leaves.present?
                    render json:{leaves_app:leaves}, status: 200
                else
                    render json:{message:"Employee don't have any leave"}, status: 404
                end
            else
                render json:{message:"You don't assigned any employee"}, status: 400
            end
        end
        
    end

    def create_leave_counter 
        if @current_employee.role == "Admin"
            begin
                manage_leave = LeaveCounter.new(leave_counter_params)
                manage_leave["employee_id"] =  Employee.find_by(name:leave_counter_params[:name]).id
                if manage_leave.save
                    render json:{message:"Leave counter ready to serve"}, status: 201
                else
                    # binding.pry
                    render json:{message:manage_leave.errors.full_messages}, status: 400
                end
            rescue ActiveRecord::RecordNotUnique => e 
                render json:{message:e.message}, status: 400
            end
        else
            render json:{message:"Only super admin have access"}, status: 400
        end
    end

    def read_leave_counter 
        if @current_employee.role == "Admin"
            leave_list = LeaveCounter.all.select(:id,:year,:leaves)
            leave_list = LeaveCounter.joins(:employee).all.select('employees.name AS employee_name,
                leave_counters.id,leave_counters.leaves')
            if leave_list.present?
                render json:{employee_leave_counter:leave_list}, status: 200
            else
                render json:{message:"Leave counter not ready, pls create first"}, status: 404
            end
        end
    end

    def create_leave_app 
        if @current_employee
            if @current_employee.role == "Employee" || @current_employee.role == "Manager"
                leave_counter = LeaveCounter.find_by(employee_id:@current_employee.id)
                if (leave_counter.leaves > 0) && (leave_counter.leaves >=  leave_app_params["no_of_paid_leave"])
                    begin
                        leave_app = Empleave.new(leave_app_params)
                        leave_app["remaining_leaves"] = leave_counter.leaves
                        leave_app["employee_id"] = @current_employee.id
                        if leave_app.save
                            render json:{message:"Leave application created successfully"}, status: 201
                        else
                            render json:{message:leave_app.errors.full_messages}, status: 400
                        end
                    rescue ActiveRecord::RecordNotUnique => e 
                        render json:{message:e.message}, status: 400
                    end
                else
                    render json:{mesagge:"Paid leave does not remaining, pls contact to your maaager"}, status: 400
                end
            elsif @current_employee.role == "Manager" && leave_app_params["self"]==false
                leave_counter = LeaveCounter.find_by(employee_id:leave_app_params["employee_id"])
                if (leave_counter.leaves > 0) && (leave_counter.leaves >=  leave_app_params["no_of_paid_leave"])
                    begin
                        leave_app = Empleave.new(leave_app_fields)
                        if leave_app_fields["status"] == "Approved"
                            leave_app["remaining_leaves"] = leave_counter.leaves - leave_app_params["no_of_paid_leave"]
                            if leave_app.save
                                leave_counter.update(leaves:(leave_counter.leaves - leave_app["no_of_paid_leave"]))
                                render json:{message:"Leave application created successfully"}, status: 201
                            else
                                render json:{message:leave_app.errors.full_messages}, status: 400
                            end
                        else
                            leave_app["remaining_leaves"] = leave_counter.leaves
                            if leave_app.save
                                render json:{message:"Leave application created successfully"}, status: 201
                            else
                                render json:{message:leave_app.errors.full_messages}, status: 400
                            end
                        end
                    rescue ActiveRecord::RecordNotUnique => e 
                        render json:{message:e.message}, status: 400
                    end
                else
                    render json:{mesagge:"Paid leave does not exit"}, status: 400
                end
            end
        else
            render json:{message:"Only authenticated uesr can make this request"}, status: 400
        end
    end

    def update_leave_app
        if @current_employee.role == "Manager" || @current_employee.role == "Admin" || @current_employee.role == "Employee"
            begin
                find_leave_app = Empleave.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e 
                render json:{message:e.message}, status: 400
            end
            # binding.pry
            employee = Employee.find(find_leave_app.employee_id)
            if employee.associated_manager_id == @current_employee.id
                if leave_app_params["status"] == "Approved"
                    update_leave_counter = LeaveCounter.find_by(employee_id:find_leave_app.employee_id)
                    find_leave_app.remaining_leaves = update_leave_counter.leaves - find_leave_app["no_of_paid_leave"]
                    # binding.pry
                    if find_leave_app.update(leave_app_params)
                        update_leave_counter.update(leaves:(update_leave_counter.leaves - find_leave_app["no_of_paid_leave"]))
                        render json:{message:"Leave application updated succcessfully"}, status:201
                    else
                        render json:{message:find_leave_app.errrs.full_messages}, status: 400
                    end
                else
                    if find_leave_app.update(leave_app_params)
                        render json:{message:"Leave application updated succcessfully"}, status:201
                    else
                        render json:{message:find_leave_app.errrs.full_messages}, status: 400
                    end
                end
            elsif @current_employee.id = employee.id
                if find_leave_app.status == "Pending"
                    if find_leave_app.update(leave_app_params)
                        render json:{message:"Leave application updated successfully"}, status: 200
                    else
                        render json:{message:"Failed to update leave application"}, status: 400
                    end
                end
            else
                render json:{message:"Pls check your leave application"}, status: 400
            end
        end
    end

    private
    def leave_counter_params
        params.require(:leave_counters_fields).permit(:employee_id,:leaves,:year)
    end

    def leave_app_params
        params.require(:leave_application).permit(:reason,:start_date,:end_date,:no_of_paid_leave,:status,:half_day,
        :wfh,:self,:remaining_leaves)
    end
end