class RenameEmployeeIdToReviewerIdInQuarterAppraisalRemark < ActiveRecord::Migration[7.0]
  def change
    rename_column :quarterly_appraisal_remarks, :employee_id, :reviewer_id
    rename_column :annual_summary_remarks, :employee_id, :reviewer_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
