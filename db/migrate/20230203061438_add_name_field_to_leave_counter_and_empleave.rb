class AddNameFieldToLeaveCounterAndEmpleave < ActiveRecord::Migration[7.0]
  def change
    add_column :empleaves, :employee_name, :string
    add_column :leave_counters, :employee_name, :string
  end
end
