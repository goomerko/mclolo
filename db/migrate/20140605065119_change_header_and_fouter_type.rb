class ChangeHeaderAndFouterType < ActiveRecord::Migration
  def change
    change_column :users, :header, :text
    change_column :users, :footer, :text
  end
end
