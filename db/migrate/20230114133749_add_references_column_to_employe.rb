class AddReferencesColumnToEmploye < ActiveRecord::Migration[7.0]
  def change
    add_reference :employees, :project, foreign_key: true, null: true,:default => nil
  end
end
