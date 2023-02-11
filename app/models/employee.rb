class Employee < ApplicationRecord
    paginates_per 5
    has_secure_password 
    # validates :user_name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    # validates :password, presence: true
    
    has_many :quarterly_appraisals
    has_many :annual_summaries
    has_many :histories
    has_many :employee_addresses
    has_one :employee_education_detail
    has_one :resignation_table
    has_one :employee_financial_info
    has_many :projects, foreign_key: :project_lead_id
    has_many :events
    # has_many :other_events, class_name: "Employee", foreign_key: "individual_id"
    #Ex:- :null => false
    has_many :leave_counters
    has_many :empleaves


    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!
        return self.reset_password_token
    end
       
    def password_token_valid?
        (self.reset_password_sent_at + 15.minutes) > Time.now.utc
    end
  
    def reset_password(password)
        self.reset_password_token = nil
        self.password = password
        save!
    end

    private
       
    def generate_token
        SecureRandom.hex(10)
    end
end
