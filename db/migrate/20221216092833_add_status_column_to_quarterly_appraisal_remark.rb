class AddStatusColumnToQuarterlyAppraisalRemark < ActiveRecord::Migration[7.0]
  def change
    add_column :quarterly_appraisal_remarks, :status, :string
    #Ex:- :default =>''
  end
end
