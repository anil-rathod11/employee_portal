class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :team_size
      t.references :project_lead, index: true, foreign_key: { to_table: :employees }
      t.text :additional_requirement

      t.timestamps
    end
  end
end
