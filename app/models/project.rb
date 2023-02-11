class Project < ApplicationRecord
  belongs_to :employee, foreign_key: :project_lead_id
  #Ex:- :null => false
end
