class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :role
      t.string :password_digest

      t.timestamps
    end
  end
end