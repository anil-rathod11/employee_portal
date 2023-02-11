class CreateEmployeeAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_addresses do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.integer :pincode
      t.boolean :is_temp_or_permnt

      t.timestamps
    end
  end
end
