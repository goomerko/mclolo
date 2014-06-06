class AddFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :manager, :boolean
    add_column :users, :node, :boolean
  end
end
