class CreateDownloads < ActiveRecord::Migration[7.1]
  def change
    create_table :downloads do |t|
      t.references :seller, null: false, foreign_key: true
      t.string :status
      t.string :file_url

      t.timestamps
    end
  end
end
