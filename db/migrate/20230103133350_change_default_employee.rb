class ChangeDefaultEmployee < ActiveRecord::Migration[7.0]
  def change
    change_column :employees, :aadhar_no, :string, null: true
    change_column :employees, :emer_cont_name, :string, null: true
    change_column :employees, :emer_cont_no, :string, null: true
    change_column :employees, :name, :string, null: false
    change_column :employees, :email, :string, null: false
  end
end
