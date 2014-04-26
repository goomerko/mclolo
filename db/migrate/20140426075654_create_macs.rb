class CreateMacs < ActiveRecord::Migration
  def change
    create_table :macs do |t|
      t.string   "mac"
      t.string   "comment"
      t.string   "node"
      t.string   "email"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "blocked",    :default => false
      t.integer :user_id
      t.timestamps
    end
  end
end
