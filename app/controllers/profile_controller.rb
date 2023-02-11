class ProfileController < ApplicationController
    before_action :authorize_request

    def get_employee_address 
        if @current_employee
            if params[:employee_id].present? && @current_employee.role == "Super Admin"
                address = EmployeeAddress.where(employee_id:params[:employee_id].to_i)
            else
                address = EmployeeAddress.where(employee_id:@current_employee.id)
            end
            if address.present?
                if  address.count == 2
                    address1 = []
                    address2 = []
                    address.each do |object|
                        # binding.pry
                        if object.is_temp == true
                            address1.push(object)
                        else
                            address2.push(object)
                        end
                    end
                    render json:{address_fields1:address1[0],address_fields2: address2[0]}, status: 200
                else
                    render json:{address_fields1:address[0],address_fields2: address[0]}, status: 200
                end
            else
                return render json:{message:"Employee address does not exit!",address_fields1:"",address_fields2:""}, status: 404
            end
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end

    def employee_address 
        if @current_employee
            if @current_employee.role == "Super Admin"
                create_address1 = EmployeeAddress.new(address_params1)
            else
                create_address1 = EmployeeAddress.new(address_params1)
                create_address1["employee_id"] = @current_employee.id
            end
            if address_params1["is_permanent_same_as_temp"] == true
                if create_address1.save
                    render json:{message:"Address submitted successfully",address_fields1:create_address1}, status: 201
                else
                    # render json:{message:"Failed to submit address"}, status: 400
                    render json:{message:create_address1.errors.full_messages}, status: 400
                end
            else
                create_address2 = EmployeeAddress.new(address_params2)
                create_address2["employee_id"] = @current_employee.id
                if create_address2.save && create_address1.save
                    render json:{message:"Address submitted successfully",address_fields1:create_address1,address_fields2:create_address2}, status: 201
                else
                    render json:{message:"Failed to submit address"}, status: 400
                end
            end
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end


    def update_employee_address
        if @current_employee || @current_employee.role == "Super Admin"
            begin
                find_exiting_address = EmployeeAddress.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
               return render json:{message:e.message,address_fields:""}, status: 404
            end
            if address_params1["is_permanent_same_as_temp"] == true
                if find_exiting_address.update(address_params1)
                    render json:{message:"Employee address updated succcessfully"},status: 201
                else
                    render json:{message:"Failed to updated employee address"}, status: 400
                end
            elsif address_params1["is_temp"] == true
                if find_exiting_address.update(address_params1)
                    render json:{message:"Employee address updated succcessfully"},status: 201
                else
                    render json:{message:"Failed to updated employee address"}, status: 400
                end
            elsif address_params1["is_temp"] == false
                if find_exiting_address.update(address_params1)
                    render json:{message:"Employee address updated succcessfully"},status: 201
                else
                    render json:{message:"Failed to updated employee address"}, status: 400
                end
            else
                find_exiting_address = EmployeeAddress.where(employee_id:@current_employee.id)
                find_exiting_address.each do |object|
                    if object.is_temp == true
                        object.update(address_params1)
                    else
                        object.update(address_params2)
                    end
                end
                render json:{message:"Employee address updated succcessfully"},status: 201
            end
        else
            render json:{message:"Only authenticated user can make this request"}, status: 400
        end
    end

    def get_employee_education_detail 
        if @current_employee
            if params[:employee_id].present? && @current_employee.role == "Super Admin"
                education = EmployeeEducationDetail.where(employee_id:params[:employee_id].to_i)
            else
                education = EmployeeEducationDetail.where(employee_id:@current_employee.id)
            end
            if education.present?
                render json:{education_fields:education[0]}, status: 200
            else
                render json:{message:"Employee education details does not exit!",education_fields:""}, status: 404
            end     
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end
    def employee_education_detail 
        if @current_employee
            if @current_employee.role == "Super Admin"
                education_detail = EmployeeEducationDetail.new(education_params)
            else
                education_detail = EmployeeEducationDetail.new(education_params)
                create_address1["employee_id"] = @current_employee.id
            end
            if education_detail.save
                render json:{message:"Education details submitted successfully",education_fields:education_detail}, status: 201
            else
                render json:{message:education_detail.errors.full_messages}, status: 400
            end
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end
    def update_employee_education_detail
        if @current_employee || @current_employee.role == "Super Admin"
            begin
                find_exiting_record = EmployeeEducationDetail.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
               return render json:{message:e.message}, status: 404
            end
            if find_exiting_record.update(education_params)
                render json:{message:"Employee education details updated succcessfully",education_fields:find_exiting_record},status: 201
            else
                render json:{message:find_exiting_record.errors.full_messages}, status: 400
            end
        else
            render json:{message:"Only authenticated user can make this request"}, status: 400
        end
    end
    def get_employee_financial_info 
        if @current_employee
            if params[:employee_id].present? && @current_employee.role == "Super Admin"
                find_exiting_record = EmployeeFinancialInfo.where(employee_id:params[:employee_id].to_i)
            else
                find_exiting_record = EmployeeFinancialInfo.where(employee_id:@current_employee.id)
            end
            if find_exiting_record
                render json:{financial_fields:find_exiting_record[0]}, status: 200
            else
               return render json:{message:"Employee financial details does not exit!",financial_fields:""}, status: 404
            end     
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end
    def employee_financial_info 
        if @current_employee
            if @current_employee.role == "Super Admin"
                financial_detail = EmployeeFinancialInfo.new(financial_params)
            else
                financial_detail = EmployeeFinancialInfo.new(financial_params)
                financial_detail["employee_id"] = @current_employee.id
            end
            if financial_detail.save
                render json:{message:"Financial details submitted successfully",financial_fields:financial_detail}, status: 201
            else
                render json:{message:financial_detail.errors.full_messages}, status: 400
            end
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end
    def update_employee_financial_info
        if @current_employee || @current_employee.role == "Super Admin"
            begin
                find_exiting_record = EmployeeFinancialInfo.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
               return render json:{message:e.message}, status: 404
            end
            if find_exiting_record.update(financial_params)
                render json:{message:"Employee financial info updated succcessfully",financial_fields:find_exiting_record},status: 201
            else
                render json:{message:"Failed to updated employee financial info"}, status: 400
            end
        else
            render json:{message:"Only authenticated user can make this request"}, status: 400
        end
    end
    def get_employee_additional_info
        if @current_employee
            if params[:employee_id].present? && @current_employee.role == "Super Admin"
                get_employee = Employee.find(params[:employee_id].to_i)
            else
                get_employee = Employee.find(@current_employee.id)
            end
            render json:{employee_additional_details:get_employee}, status: 200
        else
            render json:{message:"Unauthorize request"}, status: 400
        end 
    end
    def employee_additional_info
        if @current_employee
            if @current_employee.role == "Super Admin"
                id = params[:id]
            else
                id = @current_employee.id
            end
            begin
                get_data = Employee.find(id) 
            rescue ActiveRecord::RecordNotFound => e
               return render json:{message:e.message}, status: 404
            end 
            if get_data.update(update_employee_add_info)
                render json:{message:"Employee additional info updated succcessfully",employee_additional_details:get_data}, status: 201
            else
                render json:{message:"Failed to update additional info"}, status: 400
            end
        else
            render json:{message:"Unauthorize request"}, status: 400
        end
    end
    private
    def address_params1
        params.require(:address_fields1).permit(:address_line1,:address_line2,:city,:state,:pincode,:country,:is_permanent_same_as_temp,:is_temp,:employee_id)
    end
    def address_params2
        params.require(:address_fields2).permit(:address_line1,:address_line2,:city,:state,:pincode,:country,:is_permanent_same_as_temp,:is_temp,:employee_id)
    end
    def education_params
        params.require(:education_fields).permit(:degree,:year,:college_name,:university_name,:city,:state,:employee_id)
    end
    def financial_params
        params.require(:financial_fields).permit(:PAN_no,:UAN_no,:bank_ac_no,:bank_name,:branch_name,:IFSC_code,:employee_id)
    end

    def update_employee_add_info
        params.require(:employee_additional_details).permit(:salut,:date_of_birth,:aadhar_no,:passport_no,:visa_status,
        :date_of_joining,:emer_cont_name,:emer_cont_no,:altr_emer_cont_name,:altr_emer_cont_no,:blood_group,:designation)
    end
end