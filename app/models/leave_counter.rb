class LeaveCounter < ApplicationRecord
  belongs_to :employee
  # validates :year, :employee_id, :presence => true, :uniqueness => true
end
