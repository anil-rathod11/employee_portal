class CreateAnnualSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :annual_summaries do |t|
      t.integer :year
      t.text :accumplishment
      t.text :development_need
      t.text :career_goals
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
