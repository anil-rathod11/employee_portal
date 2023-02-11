class ChangeColumnDatatype < ActiveRecord::Migration[7.0]
  def change
    change_column :histories, :associated_manager, :integer
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
