class AddWebsiteNameToSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :website_name, :string
  end
end
