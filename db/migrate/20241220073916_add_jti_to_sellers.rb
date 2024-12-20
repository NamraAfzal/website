class AddJtiToSellers < ActiveRecord::Migration[7.1]
  def change
    add_column :sellers, :jti, :string
    add_index :sellers, :jti, unique: true
  end
end
