class CreateNodesUsers < ActiveRecord::Migration
  def change
    create_table :nodes_users, id: false do |t|
      t.integer :user_id, :node_id
    end

    add_index :nodes_users, :user_id
    add_index :nodes_users, :node_id
  end
end
