class CreateAnnualSummaryRemarks < ActiveRecord::Migration[7.0]
  def change
    create_table :annual_summary_remarks do |t|
      t.references :annual_summary, null: false, foreign_key: true
      t.text :accumplishment_by_reviewer
      t.text :development_need_by_reviewer
      t.text :career_goals_by_reviewer
      t.references :employee, null: false, foreign_key: true
      t.string :designation
      t.string :rating

      t.timestamps
    end
  end
end
