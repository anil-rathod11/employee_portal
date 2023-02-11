class AddMultipleFieldsToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :date_of_birth, :date
    add_column :employees, :aadhar_no, :string, null: false
    add_column :employees, :passport_no, :string
    add_column :employees, :visa_status, :string
    add_column :employees, :date_of_joining, :date
    add_column :employees, :emer_cont_name, :string, null: false
    add_column :employees, :emer_cont_no, :string, null: false
    add_column :employees, :altr_emer_cont_name, :string
    add_column :employees, :altr_emer_cont_no, :string
    add_column :employees, :blood_group, :string

    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
