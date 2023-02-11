class NotificationMailerJob < ApplicationJob
  # include SideKiq::Worker
  queue_as :default
  sidekiq_options retry: false
  # sidekiq_options retry: 5
  # retry_on ErrorLoadingSite, wait: 5.minutes, queue: :low_priority 
  def perform(employee_id)
    user = Employee.find(employee_id)
    # binding.pry
    if user
      # NotificationMailerJob.perform_later args
      NotificationMailer.notification(user).deliver_later
      # render json:{message:"Mail send successfully"}, status: :ok
    end
    # else
    #   render json:{message:"employee doesnot exit"}, status: :bad_request
    # end
  end
end
