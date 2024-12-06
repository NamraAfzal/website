class AddTotalAmountToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :amount, :float
  end
end
