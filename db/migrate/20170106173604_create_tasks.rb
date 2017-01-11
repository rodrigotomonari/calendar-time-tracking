class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.references :subproject_phase, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :time
      t.integer :request_control, default: 0, limit: 8
      t.timestamps
    end
  end
end
