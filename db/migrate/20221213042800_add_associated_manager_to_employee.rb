class AddAssociatedManagerToEmployee < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :associated_manager, :integer, null: true
  end
end
