class ChangeColumnTypeOfTable < ActiveRecord::Migration[7.0]
  def change
    change_column :histories, :annual_flag, :boolean, :default => false
    change_column :histories, :archive, :boolean, :default => false
    change_column :quarterly_appraisals, :archive, :boolean, :default => false
    #Ex:- :default =>''
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
