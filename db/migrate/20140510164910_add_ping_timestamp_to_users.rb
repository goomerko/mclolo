class AddPingTimestampToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ping_timestamp, :datetime
  end
end
