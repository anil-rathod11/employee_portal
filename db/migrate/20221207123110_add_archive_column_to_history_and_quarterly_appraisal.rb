class AddArchiveColumnToHistoryAndQuarterlyAppraisal < ActiveRecord::Migration[7.0]
  def change
    add_column :quarterly_appraisals, :archive, :string
    add_column :histories, :archive, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
