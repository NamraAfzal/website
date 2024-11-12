class AddDetailToSeller < ActiveRecord::Migration[7.1]
  def change
    add_column :sellers, :company_name, :string
    add_column :sellers, :store_url, :string
  end
end
