class AddNotifyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notify_missing_tasks, :boolean, after: :name, default: true
  end
end
