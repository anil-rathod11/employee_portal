class QuarterlyAppraisal < ApplicationRecord
  belongs_to :employee
  has_many :quarterly_appraisal_remarks, dependent: :destroy
  #  class_name: "quarterly_appraisal_remark", foreign_key: "reviewer_id"
  # has_many :books, dependent: :destroy
  # has_paper_trail on: [:update,:create]
end
