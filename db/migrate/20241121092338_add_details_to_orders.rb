class AddDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_address, :text
  end
end
