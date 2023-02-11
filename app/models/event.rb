class Event < ApplicationRecord
  belongs_to :employee
  # belongs_to :project
  # belongs_to :individual, class_name: "Employee",:null =>  true
  #Ex:- :null => false
end
