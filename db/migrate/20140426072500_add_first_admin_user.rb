class AddFirstAdminUser < ActiveRecord::Migration
  def up
    User.create(email: "admin@admin.com", admin: true,
      password: 'monkeymonkey', password_confirmation: 'monkeymonkey')

  end

  def down
    User.where(email: 'admin@admin.com').first.destroy
  end
end
