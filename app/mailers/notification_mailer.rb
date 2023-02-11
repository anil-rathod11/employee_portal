class NotificationMailer < ApplicationMailer
    def notification(employee)
        @employee = employee
        mail(to: "rathodanil6512@gmail.com", subject: "Appraisal form notification")
    end
end
