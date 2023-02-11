class ChangeEvent < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :start_time, :start_datetime
    rename_column :events, :end_time, :end_datetime

    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
    change_column :events, :start_datetime, :datetime
    change_column :events, :end_datetime, :datetime
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
