class AddColumnToTables < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :salut, :string
    add_column :employee_education_details, :city, :string
    add_column :employee_education_details, :state, :string
    add_column :employee_addresses, :country, :string, :default => "India"
  end
end
