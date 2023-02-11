class PasswordMailer<ApplicationMailer


    def reset 
       @token = params[:employee].generate_password_token!
        mail(to:"rathodanil6512@gmail.com",subject:"Forgot password mail")
    end

end