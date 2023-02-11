class CreateLeaveCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_counters do |t|
      t.references :employee, foreign_key: true, :null => false
      t.float :leaves
      t.integer :year

      t.timestamps
    end
  end
end
