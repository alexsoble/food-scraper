class AddSentToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :sent, :boolean, :default => false
  end
end
