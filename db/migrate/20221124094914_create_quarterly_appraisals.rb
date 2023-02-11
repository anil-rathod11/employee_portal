class CreateQuarterlyAppraisals < ActiveRecord::Migration[7.0]
  def change
    create_table :quarterly_appraisals do |t|
      t.string :quarter
      t.integer :year
      t.references :employee, null: false, foreign_key: true
      t.text :quarterly_summary
      t.string :status

      t.timestamps
    end
  end
end
