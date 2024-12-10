class AddStripesCustomerIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :stripe_customer_id, :string
  end
end
