class AddSubmittedByColumnToHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :histories, :submitted_by, :string
  end
end
