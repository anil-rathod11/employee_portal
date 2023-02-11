class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.integer :year
      t.string :quarter
      t.string :summary
      t.string :event
      t.references :employee, null: false, foreign_key: true
      t.string :associated_manager

      t.datetime :submitted_date
    end
  end
end
