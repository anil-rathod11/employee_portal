class RemoveYearFromLeaveCounter < ActiveRecord::Migration[7.0]
  def change
    remove_column :leave_counters, :year
  end
end
