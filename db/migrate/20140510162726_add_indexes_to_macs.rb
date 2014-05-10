class AddIndexesToMacs < ActiveRecord::Migration
  def change
    add_index(:macs, [:mac, :comment])
  end
end
