class EmployeeAddress < ApplicationRecord
  belongs_to :employee
  validates :city, :state, :pincode, presence: true
end
