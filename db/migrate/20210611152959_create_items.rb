class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :category, null: false, default: ''
      t.decimal :price, null: false
      t.string :url, null: false
      t.string :image_url, null: false

      t.timestamps
    end
  end
end
