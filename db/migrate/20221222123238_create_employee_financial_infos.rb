class CreateEmployeeFinancialInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_financial_infos do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :PAN_no
      t.string :UAN_no
      t.string :bank_ac_no
      t.string :bank_name
      t.string :IFSC_code
      t.string :branch_name

      t.timestamps
    end
  end
end
