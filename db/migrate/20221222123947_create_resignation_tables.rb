class CreateResignationTables < ActiveRecord::Migration[7.0]
  def change
    create_table :resignation_tables do |t|
      t.references :employee, null: false, foreign_key: true
      t.text :resignation_reason

      t.timestamps
    end
  end
end
