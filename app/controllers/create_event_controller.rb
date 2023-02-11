class CreateEventController < ApplicationController
    before_action :authorize_request
    def current_month_employee_bdays 
        if @current_employee
            bdays = Employee.where('extract(month from date_of_birth)=?',Date.today.strftime("%m").to_i).select(:id,:name,:date_of_birth)
            if bdays.present?
                render json:{current_month_employee_bday_list:bdays}, status: 200
            else
                render json:{message:"Not any b'day in this month"}, status: 404
            end
        else
            render json:{message:"Only authenticate user can make this request"}, status: 400
        end
    end

    def send_bday_wish_mail
        if @current_employee.role == "Manager" || @current_employee.role == "Admin"
            begin
                employee_email = Employee.find(params[:id]).email
            rescue ActiveRecord::RecordNotFound => e
               return render json:{mesagge:e.message}, status: 404
            end
            render json:{message:"Wishes sent successfully...!"}, status: 200
        else
            render json:{message:"Only manager can accesss this resource"}, status: 400
        end
    end

    def read
        if @current_employee.role == "Admin"
            get_event = Event.where('extract(month from created_at)=?',Date.today.strftime("%m").to_i).select(:title,:description,:start_datetime,:end_datetime)
            if get_event.present?
                render json:{current_event:get_event}, status: 200
            else
                render json:{message:"No any current month Event for you"}, status: 404
            end 
        elsif @current_employee.role == "Manager" || @current_employee.role == "Employee"
            # get_Event =  Event.where('extract(month from created_at)=?',Date.today.strftime("%m").to_i).where(individual_id:@current_employee.id).or(Event.where('extract(month from created_at)=?',Date.today.strftime("%m").to_i).where(project_id:@current_employee.project_id))
            get_event = Event.where('extract(month from updated_at)=?',Date.today.strftime("%m").to_i).where(individual_id:4).or(Event.where('extract(month from created_at)=?',Date.today.strftime("%m").to_i).where(project_id:1)).or(Event.where('extract(month from created_at)=?',Date.today.strftime("%m").to_i).where(organized_for:"Organization")).select(:title,:description,:start_datetime,:end_datetime)
            if get_event.present?
                render json:{current_event:get_event}, status: 200
            else
                render json:{message:"No any current month Event for you"}, status: 404
            end

        else
            render json:{message:"Only authenticated user can allowed"}, status: 400
        end
    end

    def create
        if @current_employee.role == "Admin" || @current_employee.role == "Manager"
            begin
                event = Event.new(event_params)
                event.employee_id = @current_employee.id
                # binding.pry
                if event.save
                    render json:{message:"Event created succcessfully"}, status: 201
                else
                    render json:{message:event.errors.full_messages}, status: 400
                end
            rescue ActiveRecord::InvalidForeignKey => e
                render json:{message:e.message}, status: 400
            end
        else
            render json:{message:"Only admin and manager can access this resources"}, status: 400
        end
    end

    def update
        if @current_employee.role == "Admin" || @current_employee.role == "Manager"
            begin
                find_record = Event.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                render json:{message:e.message}, status: 404
            end
            if @current_employee.id == find_record.employee_id
                if find_record.employee_id == @current_employee.id
                    if find_record.update(event_params)
                        render json:{message:"Event updated successfully"}, status: 201
                    else
                        render json:{message:find_record.errors.full_messages}, status: 400
                    end
                else
                    render json:{message:"Please check you Event id"}, status: 400
                end
            else
                render json:{message:"Please check your Event id"}, status: 400
            end
        else
            render json:{message:"Only admin and manager can access this action"}, status:400
        end
    end

    def soft_destroy
        if @current_employee.role == "Admin" || @current_employee.role == "Manager"
            begin
                find_exiting_record = Event.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                render json:{message:e.message}, status: 404
            end
            if find_exiting_record.employee_id == @current_employee.id
                if find_exiting_record.update(archive: true)
                    render json:{message:"Event archived successfully"}, status: 200
                else
                    render json:{message:find_exiting_record.errors.full_messages}, status: 400
                end 
            else
                render json:{message:"Please check you Event id"}, status: 400
            end
        else
            render json:{message:"Only manager and admin can destroy Event"}, status: 400
        end
    end
    
    def destroy
        if @current_employee.role == "Admin" || @current_employee.role == "Manager"
            begin
                find_exiting_record = Event.find(params[:id])
            rescue ActiveRecord::RecordNotFound => e
                render json:{message:e.message}, status: 404
            end
            if find_exiting_record.employee_id == @current_employee.id
                if find_exiting_record.archive == true
                    if find_exiting_record.destroy
                        render json:{message:"Archieved record destroy succcessfully"}, status: 200
                    else
                        render json:{message:find_exiting_record.errors.full_messages}, status: 400
                    end
                else
                    render json:{message:"Only archived record can delete"}, status: 400
                end
            else
                render json:{message:"Please check you Event id"}, status: 400
            end
        else
            render json:{message:"Only manager and admin can access this resource"}, status: 400
        end
    end

    private

    def event_params
        params.require(:event_fields).permit(:title,:description,:start_datetime,:end_datetime,:status,:archive,:organized_for,:project_id,:individual_id)
        # params.permit(:title,:description,:start_time,:end_time,:status,:archive,:organized_for,:project_id,:individual_id)
    end

end