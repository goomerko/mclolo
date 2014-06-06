class RemoveNodeFromMacs < ActiveRecord::Migration
  def up
    remove_column :macs, :node
  end

  def down
    add_column :macs, :node, :string
  end
end
