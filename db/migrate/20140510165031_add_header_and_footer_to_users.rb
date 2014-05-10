class AddHeaderAndFooterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :header, :string
    add_column :users, :footer, :string
  end
end
