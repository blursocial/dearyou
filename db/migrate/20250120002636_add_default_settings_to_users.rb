class AddDefaultSettingsToUsers < ActiveRecord::Migration[7.1]
  def change
    User.find_each do |user|
      user.update_setting("auto_accept_follows", "false") unless user.setting("auto_accept_follows").present?
    end
  end
end
