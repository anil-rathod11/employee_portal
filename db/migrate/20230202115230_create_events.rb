class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.time :start_time
      t.time :end_time
      t.string :status, :default => "Active"
      t.boolean :archive, :default => false
      t.string :organized_for
      t.references :project, null: true, foreign_key: true
      t.references :individual,null: true, foreign_key: { to_table: 'employees' }

      t.timestamps
    end
  end
end
