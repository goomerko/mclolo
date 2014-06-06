class AddNodeIdToMacs < ActiveRecord::Migration
  def change
    add_column :macs, :node_id, :integer
  end
end
