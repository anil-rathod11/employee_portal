class AnnualSummary < ApplicationRecord
  belongs_to :employee
  has_one :annual_summary_remarks, class_name: "annual_summary_remarks", foreign_key: "reviewer_id"
end
