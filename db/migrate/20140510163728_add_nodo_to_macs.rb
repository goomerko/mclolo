class AddNodoToMacs < ActiveRecord::Migration
  def change
    add_index :macs, :node
  end
end
