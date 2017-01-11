class CreateSubprojects < ActiveRecord::Migration[5.0]
  def change
    create_table :subprojects do |t|
      t.string :name
      t.references :project, foreign_key: { on_delete: :cascade }
      t.text :info
      t.integer :total_estimated_hours
      t.integer :total_consumed_hours
      t.string :status

      t.timestamps
    end
  end
end
