class CreateSubprojectPhases < ActiveRecord::Migration[5.0]
  def change
    create_table :subproject_phases do |t|
      t.references :subproject, foreign_key: { on_delete: :cascade }
      t.references :phase, foreign_key: { on_delete: :cascade }
      t.integer :estimated_hours

      t.timestamps
    end
  end
end
