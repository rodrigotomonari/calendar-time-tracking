class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :client, foreign_key: { on_delete: :cascade }
      t.string :color
      t.string :color_border
      t.string :status

      t.timestamps
    end
  end
end
