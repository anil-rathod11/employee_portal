class CreateEmpleaves < ActiveRecord::Migration[7.0]
  def change
    create_table :empleaves do |t|
      t.references :employee, foreign_key: true,:null => false
      t.text :reason
      t.date :start_date
      t.date :end_date
      t.float :no_of_paid_leave
      t.string :status, :default => "Pending"
      t.boolean :half_day, :default => false
      t.boolean :wfh, :default => false
      t.float :remaining_leaves
      t.boolean :self, :default => true

      t.timestamps
    end
  end
end
