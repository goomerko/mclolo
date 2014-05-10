class AddIfaceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :iface, :string
  end
end
