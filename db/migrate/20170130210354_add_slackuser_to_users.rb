class AddSlackuserToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :slackuser, :string, after: :notify_missing_tasks
  end
end
