class AddReferencesToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_reference :employees, :employee, null: true, foreign_key: true
  end
end
