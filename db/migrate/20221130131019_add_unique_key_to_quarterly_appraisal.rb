class AddUniqueKeyToQuarterlyAppraisal < ActiveRecord::Migration[7.0]
  def change
    add_index :quarterly_appraisals, [:employee_id, :quarter,:year], unique: true
  end
end
