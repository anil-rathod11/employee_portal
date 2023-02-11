class ChangeColumnNameToEmployee < ActiveRecord::Migration[7.0]
  def change
    rename_column :employees, :employee_id, :associated_manager_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
