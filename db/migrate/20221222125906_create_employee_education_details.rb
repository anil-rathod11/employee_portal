class CreateEmployeeEducationDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_education_details do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :degree
      t.integer :year
      t.string :college_name
      t.string :university_name

      t.timestamps
    end
  end
end
