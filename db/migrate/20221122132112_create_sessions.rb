class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :token
      t.datetime :expiry_time
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
