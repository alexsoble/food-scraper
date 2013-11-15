class AddContextToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :context, :string
  end
end
