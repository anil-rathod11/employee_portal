class CreateQuarterlyAppraisalRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :quarterly_appraisal_remarks do |t|
      t.references :quarterly_appraisal, null: false, foreign_key: true
      t.string :quarterly_summary_by_reviewer
      t.references :employee, null: false, foreign_key: true
      t.string :designation

      t.timestamps
    end
  end
end
